// Traceability: REQ-070..REQ-076 (Abschnitt 10.2), REQ-373 (Abschnitt 39
// Domain: Werkzeug-State-Machine), REQ-401..404 (Abschnitt 48 E2E-Kette),
// REQ-071/072 (Abschnitt 10.1 – Eigentümerprüfung, hier auf Modellebene
// direkt an Tool.isOwnedBy() abgesichert; siehe reports/phase6_mutation.md,
// Fund MUT-EQ: diese Methode war nach dem Phase-5-Refactor ungetestet).
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "fixtures.dart";

void main() {
  group("Tool.isOwnedBy (Abschnitt 10.1)", () {
    test("true für den tatsächlichen Eigentümer", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      expect(tool.isOwnedBy(ownerPubkey), isTrue);
    });

    test("false für einen anderen Pubkey", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      expect(tool.isOwnedBy(otherOwnerPubkey), isFalse);
    });
  });


  group("ToolStateMachine – gültige Übergänge", () {
    test("AVAILABLE -> REQUESTED ist gültig", () {
      expect(isValidToolTransition(ToolStatus.available, ToolStatus.requested), isTrue);
    });

    test("REQUESTED -> LOANED ist gültig (Bestätigung)", () {
      expect(isValidToolTransition(ToolStatus.requested, ToolStatus.loaned), isTrue);
    });

    test("REQUESTED -> AVAILABLE ist gültig (Ablehnung/Rücknahme)", () {
      expect(isValidToolTransition(ToolStatus.requested, ToolStatus.available), isTrue);
    });

    test("LOANED -> AVAILABLE ist gültig (Rückgabe)", () {
      expect(isValidToolTransition(ToolStatus.loaned, ToolStatus.available), isTrue);
    });

    test("AVAILABLE -> DELETED ist gültig", () {
      expect(isValidToolTransition(ToolStatus.available, ToolStatus.deleted), isTrue);
    });
  });

  group("ToolStateMachine – ungültige Übergänge werden verhindert (REQ Abschnitt 10.2)", () {
    final invalidCases = <(ToolStatus, ToolStatus)>[
      (ToolStatus.available, ToolStatus.loaned), // Direktsprung ohne Anfrage/Bestätigung
      (ToolStatus.loaned, ToolStatus.requested), // Rückwärtssprung
      (ToolStatus.deleted, ToolStatus.available), // gelöscht ist terminal
      (ToolStatus.deleted, ToolStatus.requested),
      (ToolStatus.deleted, ToolStatus.loaned),
      (ToolStatus.requested, ToolStatus.deleted), // Anfrage muss erst aufgelöst werden
      (ToolStatus.loaned, ToolStatus.deleted),
      (ToolStatus.available, ToolStatus.available), // Selbstübergang ist kein definierter Übergang
    ];

    for (final (from, to) in invalidCases) {
      test("$from -> $to wird abgelehnt", () {
        expect(isValidToolTransition(from, to), isFalse);
        expect(
          () => assertValidToolTransition(from, to),
          throwsA(isA<InvalidStateTransition>()),
        );
      });
    }
  });
}
