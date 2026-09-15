/// Orchestriert Werkzeug-/Leihanfrage-/Leihvorgang-Use-Cases: ruft die
/// reinen Domain-Funktionen aus `package:werkzeugkiste/domain/tool_service.dart`
/// auf und persistiert das Ergebnis über die Repositories (Application-
/// Schicht, Lastenheft Abschnitt 36 – die Domain-Funktionen selbst bleiben
/// seiteneffektfrei).
library;

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste/domain/tool_service.dart" as tool_service;

import "database_providers.dart";
import "identity_controller.dart";

/// Family-Provider: reaktive Werkzeugliste einer Community.
final toolsForCommunityProvider = StreamProvider.family<List<Tool>, String>((ref, communityId) {
  return ref.watch(toolRepositoryProvider).watchToolsForCommunity(communityId);
});

/// Family-Provider: reaktive Leihanfragen einer Community.
final loanRequestsForCommunityProvider = StreamProvider.family<List<LoanRequest>, String>((ref, communityId) {
  return ref.watch(loanRequestRepositoryProvider).watchRequestsForCommunity(communityId);
});

/// Family-Provider: reaktive Leihvorgänge einer Community.
final loansForCommunityProvider = StreamProvider.family<List<Loan>, String>((ref, communityId) {
  return ref.watch(loanRepositoryProvider).watchLoansForCommunity(communityId);
});

class LoanWorkflowController {
  LoanWorkflowController(this._ref);

  final Ref _ref;

  String get _actorPubkey {
    final identity = _ref.read(identityControllerProvider).valueOrNull;
    if (identity == null) {
      throw StateError("Keine lokale Geräte-Identität vorhanden – Onboarding nicht abgeschlossen.");
    }
    return identity.pubkey;
  }

  Future<Tool> createTool({
    required String communityId,
    required String name,
    required String category,
    String? model,
    String? description,
    String? condition,
    List<String> photoRefs = const [],
  }) async {
    final tool = Tool(
      toolId: _ref.read(idGeneratorProvider).newId(),
      ownerPubkey: _actorPubkey,
      communityId: communityId,
      name: name,
      category: category,
      model: model,
      description: description,
      condition: condition,
      photoRefs: photoRefs,
      status: ToolStatus.available,
      updatedAt: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(tool);
    return tool;
  }

  Future<Tool> editTool(
    Tool tool, {
    String? name,
    String? category,
    String? model,
    String? description,
    String? condition,
    List<String>? photoRefs,
  }) async {
    final updated = tool_service.updateTool(
      tool,
      actor: _actorPubkey,
      name: name,
      category: category,
      model: model,
      description: description,
      condition: condition,
      photoRefs: photoRefs,
      now: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(updated);
    return updated;
  }

  Future<Tool> deleteTool(Tool tool) async {
    final updated = tool_service.deleteTool(tool, actor: _actorPubkey, now: DateTime.now());
    await _ref.read(toolRepositoryProvider).upsertTool(updated);
    return updated;
  }

  Future<void> requestLoan(Tool tool) async {
    final repo = _ref.read(loanRequestRepositoryProvider);
    final activeRequests = await repo.getActiveRequestsForTool(tool.toolId);
    final result = tool_service.requestLoan(
      tool: tool,
      requesterPubkey: _actorPubkey,
      requestId: _ref.read(idGeneratorProvider).newId(),
      now: DateTime.now(),
      existingActiveRequestsForTool: activeRequests,
    );
    await _ref.read(toolRepositoryProvider).upsertTool(result.tool);
    await repo.upsertRequest(result.request);
  }

  Future<void> acceptLoanRequest(Tool tool, LoanRequest request) async {
    final result = tool_service.acceptLoanRequest(
      tool: tool,
      request: request,
      actor: _actorPubkey,
      loanId: _ref.read(idGeneratorProvider).newId(),
      now: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(result.tool);
    await _ref.read(loanRequestRepositoryProvider).upsertRequest(result.request);
    await _ref.read(loanRepositoryProvider).upsertLoan(result.loan);
  }

  Future<void> rejectLoanRequest(Tool tool, LoanRequest request) async {
    final result = tool_service.rejectLoanRequest(
      tool: tool,
      request: request,
      actor: _actorPubkey,
      now: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(result.tool);
    await _ref.read(loanRequestRepositoryProvider).upsertRequest(result.request);
  }

  Future<void> cancelLoanRequest(Tool tool, LoanRequest request) async {
    final result = tool_service.cancelLoanRequest(
      tool: tool,
      request: request,
      actor: _actorPubkey,
      now: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(result.tool);
    await _ref.read(loanRequestRepositoryProvider).upsertRequest(result.request);
  }

  Future<void> confirmReturn(Tool tool, Loan loan) async {
    final result = tool_service.confirmReturn(
      tool: tool,
      loan: loan,
      actor: _actorPubkey,
      now: DateTime.now(),
    );
    await _ref.read(toolRepositoryProvider).upsertTool(result.tool);
    await _ref.read(loanRepositoryProvider).upsertLoan(result.loan);
  }
}

final loanWorkflowControllerProvider = Provider<LoanWorkflowController>((ref) {
  return LoanWorkflowController(ref);
});
