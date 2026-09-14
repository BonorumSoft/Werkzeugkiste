// Guard-Tests für explizite MVP-Ausschlüsse (Lastenheft Abschnitt 4, 12,
// 44.3). Diese Tests sollen kompilieren UND bestehen – sie belegen, dass
// die ausgeschlossenen Felder/Funktionen im Domain-Modell nicht existieren.
// Traceability: REQ-024 (community_id Einzelwert / kein expected_return_at
// auf Tool), REQ zu Loan ohne lent_at / ohne expected_return_at.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "fixtures.dart";

void main() {
  group("Guard: MVP-Ausschlüsse (Abschnitt 4/12/44.3)", () {
    test("Tool.communityId ist ein String (Einzelwert), kein Array", () {
      final tool = buildAvailableTool();
      // Der Compiler erzwingt bereits String statt List<String> – dieser
      // Test dokumentiert und sichert das zusätzlich zur Laufzeit ab.
      expect(tool.communityId, isA<String>());
      expect(tool.toJson()["community_id"], isA<String>());
    });

    test("Tool.toJson() enthält KEIN expected_return_at", () {
      final tool = buildAvailableTool();
      expect(tool.toJson().containsKey("expected_return_at"), isFalse);
    });

    test("Loan.toJson() enthält KEIN lent_at", () {
      final loan = Loan(
        loanId: "loan-1",
        toolId: "tool-1",
        communityId: communityId,
        ownerPubkey: ownerPubkey,
        borrowerPubkey: borrowerPubkey,
        requestedAt: t0,
        acceptedAt: t0,
        status: LoanStatus.active,
      );
      expect(loan.toJson().containsKey("lent_at"), isFalse);
    });

    test("Loan.toJson() enthält KEIN expected_return_at", () {
      final loan = Loan(
        loanId: "loan-1",
        toolId: "tool-1",
        communityId: communityId,
        ownerPubkey: ownerPubkey,
        borrowerPubkey: borrowerPubkey,
        requestedAt: t0,
        acceptedAt: t0,
        status: LoanStatus.active,
      );
      expect(loan.toJson().containsKey("expected_return_at"), isFalse);
    });

    test(
      "Loan-Datenmodell erzwingt returnedAt <-> COMPLETED Kopplung "
      "(kein 'halb abgeschlossener' Zustand möglich)",
      () {
        expect(
          () => Loan(
            loanId: "loan-x",
            toolId: "tool-1",
            communityId: communityId,
            ownerPubkey: ownerPubkey,
            borrowerPubkey: borrowerPubkey,
            requestedAt: t0,
            acceptedAt: t0,
            status: LoanStatus.completed,
            returnedAt: null, // ungültig: completed ohne returnedAt
          ),
          throwsA(isA<AssertionError>()),
        );
      },
    );
  });
}
