/// Einladungs-Modell (ADR-03, `docs/adr/0003-invite-system.md`).
///
/// Der eigentliche Invite-Link/QR-Code (Token im Klartext) wird bewusst
/// AUSSERHALB von Nostr übertragen (Henne-Ei-Problem: der Pubkey des neuen
/// Mitglieds ist vorher unbekannt, siehe ADR-03). Diese Domain-Entität
/// kennt daher nur den Hash des Tokens (`tokenHash`), niemals den
/// Klartext-Token selbst – die Domain-Schicht führt keine eigene
/// Kryptografie aus (Abschnitt 23) und vergleicht ausschließlich bereits
/// von außen berechnete Hash-Werte.
library;

import "package:meta/meta.dart";

import "ids.dart";
import "state_machine.dart" as state_machine;

/// Zustand einer Einladung (ADR-03).
enum InviteStatus { pending, consumed, expired }

/// Erlaubte Zustandsübergänge (ADR-03: PENDING -> CONSUMED/EXPIRED, beide
/// Zielzustände sind terminal).
const Map<InviteStatus, Set<InviteStatus>> _allowedInviteTransitions = {
  InviteStatus.pending: {InviteStatus.consumed, InviteStatus.expired},
  InviteStatus.consumed: {},
  InviteStatus.expired: {},
};

bool isValidInviteTransition(InviteStatus from, InviteStatus to) =>
    state_machine.isValidTransition(_allowedInviteTransitions, from, to);

void assertValidInviteTransition(InviteStatus from, InviteStatus to) =>
    state_machine.assertValidTransition(_allowedInviteTransitions, from, to);

/// Einladungs-Datensatz (ADR-03).
///
/// GUARD (ADR-03): Dieses Modell besitzt bewusst KEIN Feld für den
/// Klartext-Token – nur `tokenHash`.
@immutable
final class Invite {
  const Invite({
    required this.inviteId,
    required this.communityId,
    required this.createdByPubkey,
    required this.tokenHash,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    this.consumedByPubkey,
    this.consumedAt,
    this.schemaVersion = 1,
  })  : assert(inviteId.length > 0, "inviteId darf nicht leer sein"),
        assert(tokenHash.length > 0, "tokenHash darf nicht leer sein"),
        assert(
          (status == InviteStatus.consumed) == (consumedByPubkey != null),
          "consumedByPubkey muss genau dann gesetzt sein, wenn status == consumed",
        );

  final InviteId inviteId;
  final CommunityId communityId;

  /// Das Mitglied, das die Einladung erzeugt hat.
  final Pubkey createdByPubkey;

  /// Hash des Klartext-Tokens – niemals der Token selbst (siehe
  /// Klassendokumentation und ADR-03).
  final String tokenHash;

  final DateTime createdAt;
  final DateTime expiresAt;
  final InviteStatus status;

  /// Pubkey des neuen Mitglieds, das die Einladung eingelöst hat.
  /// `null`, solange die Einladung nicht CONSUMED ist.
  final Pubkey? consumedByPubkey;
  final DateTime? consumedAt;

  final int schemaVersion;

  /// Rein zeitlicher Vergleich, unabhängig vom aktuellen [status] – ob
  /// eine Einladung tatsächlich noch eingelöst werden darf, entscheidet
  /// `invite_service.dart::consumeInvite()`, nicht diese Methode allein.
  bool isExpiredAt(DateTime now) => now.isAfter(expiresAt) || now.isAtSameMomentAs(expiresAt);

  /// Reiner Zustandswechsel PENDING -> CONSUMED, erzwungen über die
  /// Invite-State-Machine. Enthält bewusst KEINE Geschäftslogik (Ablauf-/
  /// Token-Prüfung) – das ist Aufgabe von `invite_service.dart`, analog zur
  /// Trennung zwischen `LoanRequest.withStatus()` und `tool_service.dart`.
  Invite withConsumed({required Pubkey consumedByPubkey, required DateTime now}) {
    assertValidInviteTransition(status, InviteStatus.consumed);
    return Invite(
      inviteId: inviteId,
      communityId: communityId,
      createdByPubkey: createdByPubkey,
      tokenHash: tokenHash,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: InviteStatus.consumed,
      consumedByPubkey: consumedByPubkey,
      consumedAt: now,
      schemaVersion: schemaVersion,
    );
  }

  /// Reiner Zustandswechsel PENDING -> EXPIRED.
  Invite withExpired() {
    assertValidInviteTransition(status, InviteStatus.expired);
    return Invite(
      inviteId: inviteId,
      communityId: communityId,
      createdByPubkey: createdByPubkey,
      tokenHash: tokenHash,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: InviteStatus.expired,
      schemaVersion: schemaVersion,
    );
  }

  /// Enthält ausschließlich die im ADR-03-Vorschlag genannten Felder –
  /// insbesondere KEINEN Klartext-Token (siehe Guard-Test).
  Map<String, Object?> toJson() => {
        "invite_id": inviteId,
        "community_id": communityId,
        "created_by_pubkey": createdByPubkey,
        "token_hash": tokenHash,
        "created_at": createdAt.toIso8601String(),
        "expires_at": expiresAt.toIso8601String(),
        "status": status.name,
        "consumed_by_pubkey": consumedByPubkey,
        "consumed_at": consumedAt?.toIso8601String(),
        "schema_version": schemaVersion,
      };
}
