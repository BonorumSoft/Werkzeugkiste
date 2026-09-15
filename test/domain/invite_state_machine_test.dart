// Traceability: ADR-03 (docs/adr/0003-invite-system.md) – Einladungs-
// Zustandsautomat PENDING -> CONSUMED/EXPIRED, beide Zielzustände terminal.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/invite.dart";

void main() {
  group("InviteStateMachine – gültige Übergänge", () {
    test("PENDING -> CONSUMED ist gültig", () {
      expect(isValidInviteTransition(InviteStatus.pending, InviteStatus.consumed), isTrue);
    });

    test("PENDING -> EXPIRED ist gültig", () {
      expect(isValidInviteTransition(InviteStatus.pending, InviteStatus.expired), isTrue);
    });
  });

  group("InviteStateMachine – ungültige Übergänge werden verhindert", () {
    final invalidCases = <(InviteStatus, InviteStatus)>[
      (InviteStatus.consumed, InviteStatus.pending),
      (InviteStatus.consumed, InviteStatus.expired),
      (InviteStatus.expired, InviteStatus.pending),
      (InviteStatus.expired, InviteStatus.consumed),
      (InviteStatus.pending, InviteStatus.pending), // Selbstübergang ist kein definierter Übergang
      (InviteStatus.consumed, InviteStatus.consumed), // CONSUMED ist terminal
      (InviteStatus.expired, InviteStatus.expired), // EXPIRED ist terminal
    ];

    for (final (from, to) in invalidCases) {
      test("$from -> $to wird abgelehnt", () {
        expect(isValidInviteTransition(from, to), isFalse);
        expect(
          () => assertValidInviteTransition(from, to),
          throwsA(isA<InvalidStateTransition>()),
        );
      });
    }
  });
}
