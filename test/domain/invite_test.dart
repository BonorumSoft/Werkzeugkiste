// Traceability: ADR-03 (docs/adr/0003-invite-system.md) – Invite-Entität:
// Invarianten, Zustandswechsel-Methoden, Guard gegen Klartext-Token.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/invite.dart";

import "fixtures.dart";

Invite buildPendingInvite({
  String inviteId = "invite-001",
  DateTime? createdAt,
  DateTime? expiresAt,
}) {
  final created = createdAt ?? t0;
  return Invite(
    inviteId: inviteId,
    communityId: communityId,
    createdByPubkey: ownerPubkey,
    tokenHash: "sha256:deadbeef",
    createdAt: created,
    expiresAt: expiresAt ?? created.add(const Duration(days: 7)),
    status: InviteStatus.pending,
  );
}

void main() {
  group("Invite – Invarianten", () {
    test("consumedByPubkey muss gesetzt sein, wenn status == consumed", () {
      expect(
        () => Invite(
          inviteId: "invite-001",
          communityId: communityId,
          createdByPubkey: ownerPubkey,
          tokenHash: "sha256:deadbeef",
          createdAt: t0,
          expiresAt: t0.add(const Duration(days: 7)),
          status: InviteStatus.consumed,
          consumedByPubkey: null, // ungültig
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test("tokenHash darf nicht leer sein", () {
      expect(
        () => Invite(
          inviteId: "invite-001",
          communityId: communityId,
          createdByPubkey: ownerPubkey,
          tokenHash: "",
          createdAt: t0,
          expiresAt: t0.add(const Duration(days: 7)),
          status: InviteStatus.pending,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group("Invite.isExpiredAt", () {
    test("false vor dem Ablaufzeitpunkt", () {
      final invite = buildPendingInvite();
      expect(invite.isExpiredAt(invite.expiresAt.subtract(const Duration(minutes: 1))), isFalse);
    });

    test("true nach dem Ablaufzeitpunkt", () {
      final invite = buildPendingInvite();
      expect(invite.isExpiredAt(invite.expiresAt.add(const Duration(minutes: 1))), isTrue);
    });

    test("true genau am Ablaufzeitpunkt (Grenzfall)", () {
      final invite = buildPendingInvite();
      expect(invite.isExpiredAt(invite.expiresAt), isTrue);
    });
  });

  group("Invite.withConsumed / withExpired", () {
    test("withConsumed setzt status, consumedByPubkey und consumedAt", () {
      final invite = buildPendingInvite();
      final consumedAt = t0.add(const Duration(days: 1));
      final updated = invite.withConsumed(consumedByPubkey: borrowerPubkey, now: consumedAt);

      expect(updated.status, InviteStatus.consumed);
      expect(updated.consumedByPubkey, borrowerPubkey);
      expect(updated.consumedAt, consumedAt);
    });

    test("withExpired setzt status auf expired", () {
      final invite = buildPendingInvite();
      final updated = invite.withExpired();
      expect(updated.status, InviteStatus.expired);
    });
  });

  group("Guard: kein Klartext-Token (ADR-03)", () {
    test("toJson() enthält token_hash, aber keinen Schlüssel 'token'", () {
      final invite = buildPendingInvite();
      final json = invite.toJson();
      expect(json.containsKey("token_hash"), isTrue);
      expect(json.containsKey("token"), isFalse);
    });
  });
}
