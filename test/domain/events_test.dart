// Traceability: REQ zu Abschnitt 38 (Event-Modell: eindeutige ID,
// kryptografische Authentifizierung als Pflichtfeld).
import "package:test/test.dart";
import "package:werkzeugkiste/domain/events.dart";

void main() {
  group("DomainEvent – strukturelle Invarianten (Abschnitt 38)", () {
    test("ToolCreated trägt eventId, signerPubkey und signature", () {
      final event = ToolCreated(
        eventId: "evt-1",
        signerPubkey: "npub1abc",
        signature: "sig-placeholder",
        occurredAt: DateTime.utc(2026, 9, 12),
        toolId: "tool-1",
      );
      expect(event.eventType, "ToolCreated");
      expect(event.eventId, isNotEmpty);
      expect(event.signature, isNotEmpty);
    });

    test("ein Event ohne Signatur ist ungültig (Abschnitt 38: kryptografisch authentifiziert)", () {
      expect(
        () => ToolCreated(
          eventId: "evt-1",
          signerPubkey: "npub1abc",
          signature: "", // leer -> ungültig
          occurredAt: DateTime.utc(2026, 9, 12),
          toolId: "tool-1",
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test("alle acht in Abschnitt 38 geforderten Event-Typen existieren", () {
      final now = DateTime.utc(2026, 9, 12);
      final events = <DomainEvent>[
        ToolCreated(eventId: "e1", signerPubkey: "p", signature: "s", occurredAt: now, toolId: "t"),
        ToolUpdated(eventId: "e2", signerPubkey: "p", signature: "s", occurredAt: now, toolId: "t"),
        ToolDeleted(eventId: "e3", signerPubkey: "p", signature: "s", occurredAt: now, toolId: "t"),
        LoanRequested(eventId: "e4", signerPubkey: "p", signature: "s", occurredAt: now, requestId: "r"),
        LoanAccepted(eventId: "e5", signerPubkey: "p", signature: "s", occurredAt: now, loanId: "l"),
        LoanRejected(eventId: "e6", signerPubkey: "p", signature: "s", occurredAt: now, requestId: "r"),
        LoanCancelled(eventId: "e7", signerPubkey: "p", signature: "s", occurredAt: now, requestId: "r"),
        LoanReturned(eventId: "e8", signerPubkey: "p", signature: "s", occurredAt: now, loanId: "l"),
      ];
      final types = events.map((e) => e.eventType).toSet();
      expect(types, {
        "ToolCreated",
        "ToolUpdated",
        "ToolDeleted",
        "LoanRequested",
        "LoanAccepted",
        "LoanRejected",
        "LoanCancelled",
        "LoanReturned",
      });
    });
  });
}
