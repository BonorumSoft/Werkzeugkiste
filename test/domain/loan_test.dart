// Traceability: REQ-104..REQ-109 (Abschnitt 14 Rückgabe), REQ-098..099
// (Abschnitt 12 Zeitstempel-Semantik).
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste/domain/tool_service.dart";

import "fixtures.dart";

void main() {
  group("confirmReturn (Abschnitt 14)", () {
    late Tool loanedTool;
    late Loan activeLoan;

    setUp(() {
      loanedTool = buildAvailableTool().copyWith(status: ToolStatus.loaned);
      activeLoan = Loan(
        loanId: "loan-1",
        toolId: loanedTool.toolId,
        communityId: communityId,
        ownerPubkey: ownerPubkey,
        borrowerPubkey: borrowerPubkey,
        requestedAt: t0,
        acceptedAt: t0.add(const Duration(minutes: 5)),
        status: LoanStatus.active,
      );
    });

    test("setzt returnedAt, Loan->COMPLETED, Tool->AVAILABLE", () {
      final returnedAt = t0.add(const Duration(days: 2));
      final result = confirmReturn(
        tool: loanedTool,
        loan: activeLoan,
        actor: ownerPubkey,
        now: returnedAt,
      );

      expect(result.tool.status, ToolStatus.available);
      expect(result.loan.status, LoanStatus.completed);
      expect(result.loan.returnedAt, returnedAt);
      // requested_at/accepted_at dürfen durch die Rückgabe nicht verändert werden.
      expect(result.loan.acceptedAt, activeLoan.acceptedAt);
      expect(result.loan.requestedAt, activeLoan.requestedAt);
    });

    test("nur der Eigentümer darf die Rückgabe bestätigen", () {
      expect(
        () => confirmReturn(
          tool: loanedTool,
          loan: activeLoan,
          actor: borrowerPubkey,
          now: t0,
        ),
        throwsA(isA<PermissionDenied>()),
      );
    });

    test("ein bereits abgeschlossener Loan kann nicht erneut zurückgegeben werden", () {
      final completed = activeLoan.withReturnConfirmed(t0.add(const Duration(days: 1)));
      expect(
        () => completed.withReturnConfirmed(t0.add(const Duration(days: 2))),
        throwsA(isA<InvalidStateTransition>()),
      );
    });

    test("nach abgeschlossener Rückgabe kann erneut eine Ausleihe beantragt werden (REQ Abschnitt 14)", () {
      final returnedAt = t0.add(const Duration(days: 2));
      final result = confirmReturn(tool: loanedTool, loan: activeLoan, actor: ownerPubkey, now: returnedAt);
      // Tool ist wieder AVAILABLE -> eine neue Anfrage muss erneut möglich sein.
      expect(isValidToolTransition(result.tool.status, ToolStatus.requested), isTrue);
    });
  });
}
