// Traceability: REQ-088..REQ-092 (Abschnitt 11), REQ-093..097 (Abschnitt
// 11.1), REQ-100..103 (Abschnitt 12), REQ-249 (Abschnitt 11.1 max. eine
// aktive Anfrage pro Werkzeug, nicht pro Werkzeug+Anfragendem).
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste/domain/tool_service.dart";

import "fixtures.dart";

void main() {
  group("requestLoan", () {
    test("stellt Anfrage und markiert Werkzeug als REQUESTED", () {
      final tool = buildAvailableTool();
      final result = requestLoan(
        tool: tool,
        requesterPubkey: borrowerPubkey,
        requestId: "req-1",
        now: t0,
        existingActiveRequestsForTool: const <LoanRequest>[],
      );

      expect(result.tool.status, ToolStatus.requested);
      expect(result.request.status, LoanRequestStatus.pending);
      expect(result.request.requesterPubkey, borrowerPubkey);
      expect(result.request.ownerPubkey, ownerPubkey);
    });

    test(
      "REQ-249: zweite Anfrage für dasselbe Werkzeug wird abgelehnt, "
      "auch von einem ANDEREN Anfragenden (Regel gilt pro Werkzeug)",
      () {
        final tool = buildAvailableTool().copyWith(status: ToolStatus.requested);
        final existing = LoanRequest(
          requestId: "req-1",
          toolId: tool.toolId,
          communityId: communityId,
          requesterPubkey: borrowerPubkey,
          ownerPubkey: ownerPubkey,
          requestedAt: t0,
          status: LoanRequestStatus.pending,
        );

        expect(
          () => requestLoan(
            tool: tool,
            requesterPubkey: secondBorrowerPubkey, // != borrowerPubkey
            requestId: "req-2",
            now: t0,
            existingActiveRequestsForTool: [existing],
          ),
          throwsA(isA<DuplicateActiveLoanRequest>()),
        );
      },
    );

    test("Anfrage auf nicht-verfügbares Werkzeug schlägt fehl", () {
      final tool = buildAvailableTool().copyWith(status: ToolStatus.loaned);
      expect(
        () => requestLoan(
          tool: tool,
          requesterPubkey: borrowerPubkey,
          requestId: "req-1",
          now: t0,
          existingActiveRequestsForTool: const <LoanRequest>[],
        ),
        throwsA(isA<InvalidStateTransition>()),
      );
    });
  });

  group("acceptLoanRequest", () {
    late Tool requestedTool;
    late LoanRequest pendingRequest;

    setUp(() {
      requestedTool = buildAvailableTool().copyWith(status: ToolStatus.requested);
      pendingRequest = LoanRequest(
        requestId: "req-1",
        toolId: requestedTool.toolId,
        communityId: communityId,
        requesterPubkey: borrowerPubkey,
        ownerPubkey: ownerPubkey,
        requestedAt: t0,
        status: LoanRequestStatus.pending,
      );
    });

    test("Eigentümer kann bestätigen: Tool -> LOANED, acceptedAt gesetzt", () {
      final acceptedAt = t0.add(const Duration(minutes: 5));
      final result = acceptLoanRequest(
        tool: requestedTool,
        request: pendingRequest,
        actor: ownerPubkey,
        loanId: "loan-1",
        now: acceptedAt,
      );

      expect(result.tool.status, ToolStatus.loaned);
      expect(result.request.status, LoanRequestStatus.accepted);
      expect(result.loan.acceptedAt, acceptedAt);
      expect(result.loan.returnedAt, isNull);
      expect(result.loan.borrowerPubkey, borrowerPubkey);
    });

    test("Nicht-Eigentümer kann NICHT bestätigen (REQ Abschnitt 10.1/33)", () {
      expect(
        () => acceptLoanRequest(
          tool: requestedTool,
          request: pendingRequest,
          actor: borrowerPubkey, // ist Anfragender, nicht Eigentümer
          loanId: "loan-1",
          now: t0,
        ),
        throwsA(isA<PermissionDenied>()),
      );
    });
  });

  group("rejectLoanRequest / cancelLoanRequest", () {
    late Tool requestedTool;
    late LoanRequest pendingRequest;

    setUp(() {
      requestedTool = buildAvailableTool().copyWith(status: ToolStatus.requested);
      pendingRequest = LoanRequest(
        requestId: "req-1",
        toolId: requestedTool.toolId,
        communityId: communityId,
        requesterPubkey: borrowerPubkey,
        ownerPubkey: ownerPubkey,
        requestedAt: t0,
        status: LoanRequestStatus.pending,
      );
    });

    test("Eigentümer kann ablehnen -> Werkzeug wieder AVAILABLE", () {
      final result = rejectLoanRequest(
        tool: requestedTool,
        request: pendingRequest,
        actor: ownerPubkey,
        now: t0,
      );
      expect(result.tool.status, ToolStatus.available);
      expect(result.request.status, LoanRequestStatus.rejected);
    });

    test("Anfragender kann NICHT ablehnen (nur Eigentümer darf)", () {
      expect(
        () => rejectLoanRequest(
          tool: requestedTool,
          request: pendingRequest,
          actor: borrowerPubkey,
          now: t0,
        ),
        throwsA(isA<PermissionDenied>()),
      );
    });

    test("Anfragender kann zurückziehen -> Werkzeug wieder AVAILABLE", () {
      final result = cancelLoanRequest(
        tool: requestedTool,
        request: pendingRequest,
        actor: borrowerPubkey,
        now: t0,
      );
      expect(result.tool.status, ToolStatus.available);
      expect(result.request.status, LoanRequestStatus.cancelled);
    });

    test("Eigentümer kann NICHT für den Anfragenden zurückziehen", () {
      expect(
        () => cancelLoanRequest(
          tool: requestedTool,
          request: pendingRequest,
          actor: ownerPubkey,
          now: t0,
        ),
        throwsA(isA<PermissionDenied>()),
      );
    });
  });
}
