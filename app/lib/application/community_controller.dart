/// Orchestriert Community-/Mitglieder-/Einladungs-Use-Cases (Lastenheft
/// Abschnitt 7/9, ADR-03).
library;

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/community.dart";
import "package:werkzeugkiste/domain/invite.dart";
import "package:werkzeugkiste/domain/invite_service.dart" as invite_service;

import "database_providers.dart";
import "identity_controller.dart";

/// Reaktive Liste aller lokal bekannten Communities dieses Geräts.
final communitiesProvider = StreamProvider<List<Community>>((ref) {
  return ref.watch(communityRepositoryProvider).watchCommunities();
});

/// Reaktive Liste der Einladungen einer Community.
final invitesForCommunityProvider = StreamProvider.family<List<Invite>, String>((ref, communityId) {
  return ref.watch(inviteRepositoryProvider).watchInvitesForCommunity(communityId);
});

/// Fehler beim Einlösen einer Einladung, deren Token diesem Gerät lokal
/// unbekannt ist. In der aktuell rein lokalen (Nostr-losen) Betriebsart
/// kennt ein Gerät nur Einladungen, die es selbst erzeugt hat (siehe
/// README/ARCHITECTURE) – ein anderes Gerät könnte dasselbe Token erst nach
/// Implementierung der Nostr-Anbindung (ADR-01/02/08) einlösen.
class UnknownInviteTokenException implements Exception {
  const UnknownInviteTokenException();

  @override
  String toString() => "Dieses Einladungs-Token ist auf diesem Gerät nicht bekannt.";
}

class CommunityController {
  CommunityController(this._ref);

  final Ref _ref;

  String get _actorPubkey {
    final identity = _ref.read(identityControllerProvider).valueOrNull;
    if (identity == null) {
      throw StateError("Keine lokale Geräte-Identität vorhanden – Onboarding nicht abgeschlossen.");
    }
    return identity.pubkey;
  }

  String get _displayName {
    final identity = _ref.read(identityControllerProvider).valueOrNull;
    return identity?.displayName ?? "Ich";
  }

  Future<Community> createCommunity(String name) async {
    final communityId = _ref.read(idGeneratorProvider).newId();
    // ADR-02: communityKeyRef ist ein opaker Verweis auf das eigentliche
    // Schlüsselmaterial; die echte Schlüsselerzeugung/-verteilung ist Teil
    // der noch nicht implementierten Nostr-Anbindung. Platzhalter hier
    // analog zu `IdentityStore` (siehe dort für die ausführliche Begründung).
    final communityKeyRef = "local-placeholder-${_ref.read(idGeneratorProvider).newId()}";
    final community = Community(
      communityId: communityId,
      communityKeyRef: communityKeyRef,
      name: name,
      members: [
        Member(pubkey: _actorPubkey, displayName: _displayName, status: MembershipStatus.active),
      ],
    );
    await _ref.read(communityRepositoryProvider).upsertCommunity(community);
    return community;
  }

  /// Erzeugt eine neue Einladung. Gibt das Klartext-Token zurück, damit die
  /// UI es einmalig anzeigen/teilen kann – persistiert wird laut
  /// Domain-Design (Abschnitt 23) nur `tokenHash`, niemals das Klartext-Token
  /// selbst (siehe `lib/domain/invite.dart`/`invite_service.dart`).
  Future<({Invite invite, String plaintextToken})> createInvite(String communityId) async {
    final idGen = _ref.read(idGeneratorProvider);
    final token = idGen.newInviteToken();
    final invite = invite_service.createInvite(
      communityId: communityId,
      createdByPubkey: _actorPubkey,
      inviteId: idGen.newId(),
      tokenHash: idGen.hashToken(token),
      now: DateTime.now(),
    );
    await _ref.read(inviteRepositoryProvider).upsertInvite(invite);
    return (invite: invite, plaintextToken: token);
  }

  /// Löst ein Einladungs-Token ein. Wirft [UnknownInviteTokenException],
  /// falls dieses Gerät das Token nicht kennt, sowie die üblichen
  /// `DomainException`-Subtypen (`InviteExpired`, `InvalidStateTransition`)
  /// aus der Domain-Schicht.
  Future<Invite> redeemInvite(String plaintextToken) async {
    final idGen = _ref.read(idGeneratorProvider);
    final tokenHash = idGen.hashToken(plaintextToken);
    final inviteRepo = _ref.read(inviteRepositoryProvider);
    final invite = await inviteRepo.findByTokenHash(tokenHash);
    if (invite == null) {
      throw const UnknownInviteTokenException();
    }
    final consumed = invite_service.consumeInvite(
      invite: invite,
      providedTokenHash: tokenHash,
      consumedByPubkey: _actorPubkey,
      now: DateTime.now(),
    );
    await inviteRepo.upsertInvite(consumed);

    final communityRepo = _ref.read(communityRepositoryProvider);
    final community = await communityRepo.getCommunity(consumed.communityId);
    if (community != null && !community.hasActiveMember(_actorPubkey)) {
      final updated = Community(
        communityId: community.communityId,
        communityKeyRef: community.communityKeyRef,
        name: community.name,
        members: [
          ...community.members,
          Member(pubkey: _actorPubkey, displayName: _displayName, status: MembershipStatus.active),
        ],
      );
      await communityRepo.upsertCommunity(updated);
    }
    return consumed;
  }

  Future<void> removeMember(Community community, String pubkey) async {
    final updated = community.withMemberRemoved(pubkey);
    await _ref.read(communityRepositoryProvider).upsertCommunity(updated);
  }
}

final communityControllerProvider = Provider<CommunityController>((ref) {
  return CommunityController(ref);
});
