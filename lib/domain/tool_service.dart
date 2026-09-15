/// Orchestrierende Domain-Operationen für Werkzeuge, Leihanfragen und
/// Leihvorgänge (Lastenheft Abschnitt 10-14).
///
/// Alle Funktionen sind rein (keine Seiteneffekte, kein IO) und arbeiten
/// ausschließlich mit den unveränderlichen Domain-Modellen. Persistenz,
/// Event-Erzeugung/-Versand und Netzwerk sind Aufgabe der Application-/
/// Infrastructure-Schicht (Abschnitt 36).
library;

import "exceptions.dart";
import "ids.dart";
import "loan.dart";
import "loan_request.dart";
import "tool.dart";

/// REQ Abschnitt 10.1: Nur der Eigentümer darf ein Werkzeug bearbeiten.
Tool updateTool(
  Tool tool, {
  required Pubkey actor,
  String? name,
  String? category,
  String? model,
  String? description,
  List<String>? photoRefs,
  String? condition,
  required DateTime now,
}) {
  _assertActor(actor, tool.ownerPubkey, action: "Werkzeug bearbeiten", roleLabel: "owner_pubkey");
  return tool.copyWith(
    name: name,
    category: category,
    model: model,
    description: description,
    photoRefs: photoRefs,
    condition: condition,
    updatedAt: now,
  );
}

/// REQ Abschnitt 10.1: Nur der Eigentümer darf ein Werkzeug löschen.
/// Zustandsübergang wird über die Tool-State-Machine erzwungen (siehe
/// tool.dart: DELETED ist nur aus AVAILABLE erreichbar).
Tool deleteTool(Tool tool, {required Pubkey actor, required DateTime now}) {
  _assertActor(actor, tool.ownerPubkey, action: "Werkzeug löschen", roleLabel: "owner_pubkey");
  assertValidToolTransition(tool.status, ToolStatus.deleted);
  return tool.copyWith(status: ToolStatus.deleted, updatedAt: now);
}

/// PHASE 5 (Refactor): Bündelt das zuvor vierfach duplizierte Muster
/// "Aktor muss mit einem bestimmten Pubkey übereinstimmen, sonst
/// PermissionDenied" (Eigentümer bearbeiten/löschen/bestätigen/ablehnen,
/// Anfragender zurückziehen). Reines Verhalten unverändert – siehe
/// reports/phase5_refactor.md.
void _assertActor(
  Pubkey actual,
  Pubkey expected, {
  required String action,
  required String roleLabel,
}) {
  if (actual != expected) {
    throw PermissionDenied(action, actor: actual, requiredRole: "$roleLabel=$expected");
  }
}

/// REQ Abschnitt 11/11.1: Leihanfrage stellen.
///
/// - Werkzeug muss AVAILABLE sein (State-Machine erzwingt REQUESTED-Übergang).
/// - Pro Werkzeug darf höchstens eine aktive (PENDING) Anfrage existieren –
///   unabhängig vom Anfragenden ([existingActiveRequestsForTool] enthält
///   alle aktuell aktiven Anfragen für genau dieses Tool).
({Tool tool, LoanRequest request}) requestLoan({
  required Tool tool,
  required Pubkey requesterPubkey,
  required LoanRequestId requestId,
  required DateTime now,
  required List<LoanRequest> existingActiveRequestsForTool,
}) {
  if (existingActiveRequestsForTool.any((r) => r.isActive)) {
    throw DuplicateActiveLoanRequest(tool.toolId);
  }
  assertValidToolTransition(tool.status, ToolStatus.requested);

  final updatedTool = tool.copyWith(status: ToolStatus.requested, updatedAt: now);
  final request = LoanRequest(
    requestId: requestId,
    toolId: tool.toolId,
    communityId: tool.communityId,
    requesterPubkey: requesterPubkey,
    ownerPubkey: tool.ownerPubkey,
    requestedAt: now,
    status: LoanRequestStatus.pending,
  );
  return (tool: updatedTool, request: request);
}

/// REQ Abschnitt 11.1/12/13: Eigentümer bestätigt Anfrage.
/// `acceptedAt` markiert zugleich Beginn der Ausleihe (Abschnitt 12).
({Tool tool, LoanRequest request, Loan loan}) acceptLoanRequest({
  required Tool tool,
  required LoanRequest request,
  required Pubkey actor,
  required LoanId loanId,
  required DateTime now,
}) {
  _assertActor(actor, request.ownerPubkey, action: "Anfrage bestätigen", roleLabel: "owner_pubkey");
  assertValidToolTransition(tool.status, ToolStatus.loaned);

  final updatedRequest = request.withStatus(LoanRequestStatus.accepted);
  final updatedTool = tool.copyWith(status: ToolStatus.loaned, updatedAt: now);
  final loan = Loan(
    loanId: loanId,
    toolId: tool.toolId,
    communityId: tool.communityId,
    ownerPubkey: request.ownerPubkey,
    borrowerPubkey: request.requesterPubkey,
    requestedAt: request.requestedAt,
    acceptedAt: now,
    status: LoanStatus.active,
  );
  return (tool: updatedTool, request: updatedRequest, loan: loan);
}

/// REQ Abschnitt 11.1: Eigentümer lehnt Anfrage ab -> Werkzeug wieder
/// AVAILABLE.
({Tool tool, LoanRequest request}) rejectLoanRequest({
  required Tool tool,
  required LoanRequest request,
  required Pubkey actor,
  required DateTime now,
}) {
  _assertActor(actor, request.ownerPubkey, action: "Anfrage ablehnen", roleLabel: "owner_pubkey");
  assertValidToolTransition(tool.status, ToolStatus.available);
  return (
    tool: tool.copyWith(status: ToolStatus.available, updatedAt: now),
    request: request.withStatus(LoanRequestStatus.rejected),
  );
}

/// REQ Abschnitt 11.1: Anfragender zieht offene Anfrage zurück -> Werkzeug
/// wieder AVAILABLE.
({Tool tool, LoanRequest request}) cancelLoanRequest({
  required Tool tool,
  required LoanRequest request,
  required Pubkey actor,
  required DateTime now,
}) {
  _assertActor(actor, request.requesterPubkey, action: "Anfrage zurückziehen", roleLabel: "requester_pubkey");
  assertValidToolTransition(tool.status, ToolStatus.available);
  return (
    tool: tool.copyWith(status: ToolStatus.available, updatedAt: now),
    request: request.withStatus(LoanRequestStatus.cancelled),
  );
}

/// REQ Abschnitt 14: Eigentümer bestätigt Rückgabe.
/// Effekte: `returnedAt` gesetzt, Loan -> COMPLETED, Tool -> AVAILABLE.
({Tool tool, Loan loan}) confirmReturn({
  required Tool tool,
  required Loan loan,
  required Pubkey actor,
  required DateTime now,
}) {
  _assertActor(actor, loan.ownerPubkey, action: "Rückgabe bestätigen", roleLabel: "owner_pubkey");
  assertValidToolTransition(tool.status, ToolStatus.available);
  return (
    tool: tool.copyWith(status: ToolStatus.available, updatedAt: now),
    loan: loan.withReturnConfirmed(now),
  );
}
