/// Orchestrierende Domain-Operationen für Einladungen (ADR-03,
/// `docs/adr/0003-invite-system.md`).
///
/// Wie `tool_service.dart` sind alle Funktionen rein (keine
/// Seiteneffekte, kein IO). Insbesondere berechnet dieser Layer KEINE
/// Hashes selbst – `tokenHash`/`providedTokenHash` werden von der
/// Infrastructure-Schicht vorberechnet übergeben (Abschnitt 23: keine
/// eigene Kryptografie in der Domain-Schicht).
library;

import "exceptions.dart";
import "ids.dart";
import "invite.dart";

/// ADR-03: Standard-Gültigkeitsdauer einer Einladung, sofern beim
/// Erzeugen keine andere Dauer angegeben wird.
const Duration defaultInviteValidity = Duration(days: 7);

/// Erzeugt eine neue Einladung im Zustand PENDING.
///
/// [tokenHash] ist der von der Infrastructure-Schicht bereits berechnete
/// Hash des Klartext-Tokens (siehe `invite.dart`-Klassendokumentation).
Invite createInvite({
  required CommunityId communityId,
  required Pubkey createdByPubkey,
  required InviteId inviteId,
  required String tokenHash,
  required DateTime now,
  Duration validFor = defaultInviteValidity,
}) {
  return Invite(
    inviteId: inviteId,
    communityId: communityId,
    createdByPubkey: createdByPubkey,
    tokenHash: tokenHash,
    createdAt: now,
    expiresAt: now.add(validFor),
    status: InviteStatus.pending,
  );
}

/// ADR-03: Löst eine Einladung ein.
///
/// Prüft in dieser Reihenfolge:
/// 1. Token-Hash muss übereinstimmen ([InvalidInviteToken]).
/// 2. Einladung darf nicht abgelaufen sein ([InviteExpired]) – zeitliche
///    Vorbedingung, unabhängig vom gespeicherten [Invite.status].
/// 3. Zustandsübergang PENDING -> CONSUMED muss gültig sein
///    ([InvalidStateTransition]) – das schließt insbesondere eine
///    zweite Einlösung derselben Einladung aus (Einmalverwendung).
Invite consumeInvite({
  required Invite invite,
  required String providedTokenHash,
  required Pubkey consumedByPubkey,
  required DateTime now,
}) {
  if (providedTokenHash != invite.tokenHash) {
    throw InvalidInviteToken(invite.inviteId);
  }
  if (invite.isExpiredAt(now)) {
    throw InviteExpired(invite.inviteId);
  }
  return invite.withConsumed(consumedByPubkey: consumedByPubkey, now: now);
}
