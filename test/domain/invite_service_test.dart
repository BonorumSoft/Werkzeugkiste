// Traceability: ADR-03 (docs/adr/0003-invite-system.md) – createInvite/
// consumeInvite: Standard-Gültigkeitsdauer, Token-Prüfung, Ablauf-Prüfung,
// Einmalverwendung.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/invite.dart";
import "package:werkzeugkiste/domain/invite_service.dart";

import "fixtures.dart";

void main() {
  group("createInvite", () {
    test("erzeugt eine PENDING-Einladung mit Standard-Gültigkeit von 7 Tagen", () {
      final invite = createInvite(
        communityId: communityId,
        createdByPubkey: ownerPubkey,
        inviteId: "invite-001",
        tokenHash: "sha256:deadbeef",
        now: t0,
      );

      expect(invite.status, InviteStatus.pending);
      expect(invite.createdAt, t0);
      expect(invite.expiresAt, t0.add(const Duration(days: 7)));
      expect(invite.createdByPubkey, ownerPubkey);
    });

    test("akzeptiert eine abweichende Gültigkeitsdauer", () {
      final invite = createInvite(
        communityId: communityId,
        createdByPubkey: ownerPubkey,
        inviteId: "invite-001",
        tokenHash: "sha256:deadbeef",
        now: t0,
        validFor: const Duration(days: 1),
      );
      expect(invite.expiresAt, t0.add(const Duration(days: 1)));
    });
  });

  group("consumeInvite", () {
    late Invite pendingInvite;

    setUp(() {
      pendingInvite = createInvite(
        communityId: communityId,
        createdByPubkey: ownerPubkey,
        inviteId: "invite-001",
        tokenHash: "sha256:deadbeef",
        now: t0,
      );
    });

    test("löst eine gültige Einladung ein -> CONSUMED", () {
      final consumedAt = t0.add(const Duration(hours: 1));
      final result = consumeInvite(
        invite: pendingInvite,
        providedTokenHash: "sha256:deadbeef",
        consumedByPubkey: borrowerPubkey,
        now: consumedAt,
      );

      expect(result.status, InviteStatus.consumed);
      expect(result.consumedByPubkey, borrowerPubkey);
      expect(result.consumedAt, consumedAt);
    });

    test("falscher Token-Hash wird abgelehnt (InvalidInviteToken)", () {
      expect(
        () => consumeInvite(
          invite: pendingInvite,
          providedTokenHash: "sha256:falsch",
          consumedByPubkey: borrowerPubkey,
          now: t0,
        ),
        throwsA(isA<InvalidInviteToken>()),
      );
    });

    test("abgelaufene Einladung wird abgelehnt (InviteExpired), auch mit korrektem Token", () {
      expect(
        () => consumeInvite(
          invite: pendingInvite,
          providedTokenHash: "sha256:deadbeef",
          consumedByPubkey: borrowerPubkey,
          now: pendingInvite.expiresAt.add(const Duration(minutes: 1)),
        ),
        throwsA(isA<InviteExpired>()),
      );
    });

    test("bereits eingelöste Einladung kann nicht erneut eingelöst werden (Einmalverwendung)", () {
      final firstConsumption = consumeInvite(
        invite: pendingInvite,
        providedTokenHash: "sha256:deadbeef",
        consumedByPubkey: borrowerPubkey,
        now: t0.add(const Duration(hours: 1)),
      );

      expect(
        () => consumeInvite(
          invite: firstConsumption,
          providedTokenHash: "sha256:deadbeef",
          consumedByPubkey: secondBorrowerPubkey, // andere Person versucht denselben Token
          now: t0.add(const Duration(hours: 2)),
        ),
        throwsA(isA<InvalidStateTransition>()),
      );
    });

    test("Token-Prüfung hat Vorrang vor Ablauf-Prüfung (falscher Token trotz Ablauf -> InvalidInviteToken)", () {
      expect(
        () => consumeInvite(
          invite: pendingInvite,
          providedTokenHash: "sha256:falsch",
          consumedByPubkey: borrowerPubkey,
          now: pendingInvite.expiresAt.add(const Duration(minutes: 1)),
        ),
        throwsA(isA<InvalidInviteToken>()),
      );
    });
  });
}
