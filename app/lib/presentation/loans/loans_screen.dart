import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "../../application/identity_controller.dart";
import "../../application/loan_workflow_controller.dart";
import "../utils/list_ext.dart";

/// Übergreifende "Inbox": eigene offene Anfragen, Anfragen für die eigenen
/// Werkzeuge, sowie aktive Ausleihen – ergänzt die werkzeugbezogene Sicht in
/// `ToolDetailScreen` um eine community-weite Übersicht (Lastenheft
/// Abschnitt 11/12/14).
class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key, required this.communityId});

  final String communityId;

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        final message = e is DomainException ? e.message : "$e";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsAsync = ref.watch(toolsForCommunityProvider(communityId));
    final requestsAsync = ref.watch(loanRequestsForCommunityProvider(communityId));
    final loansAsync = ref.watch(loansForCommunityProvider(communityId));
    final myPubkey = ref.watch(identityControllerProvider).valueOrNull?.pubkey;
    final controller = ref.read(loanWorkflowControllerProvider);

    if (toolsAsync.isLoading || requestsAsync.isLoading || loansAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final tools = toolsAsync.valueOrNull ?? const <Tool>[];
    final requests = requestsAsync.valueOrNull ?? const <LoanRequest>[];
    final loans = loansAsync.valueOrNull ?? const <Loan>[];

    Tool? toolFor(String toolId) => tools.firstWhereOrNull((t) => t.toolId == toolId);

    final myOpenRequests = requests
        .where((r) => r.status == LoanRequestStatus.pending && r.requesterPubkey == myPubkey)
        .toList();
    final requestsOnMyTools = requests
        .where((r) => r.status == LoanRequestStatus.pending && r.ownerPubkey == myPubkey)
        .toList();
    final activeLoans = loans.where((l) => l.status == LoanStatus.active).toList();

    if (myOpenRequests.isEmpty && requestsOnMyTools.isEmpty && activeLoans.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("Aktuell keine offenen Anfragen oder aktiven Ausleihen.", textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (requestsOnMyTools.isNotEmpty) ...[
          Text("Anfragen für deine Werkzeuge", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final request in requestsOnMyTools)
            _RequestTile(
              request: request,
              tool: toolFor(request.toolId),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    tooltip: "Annehmen",
                    onPressed: () {
                      final tool = toolFor(request.toolId);
                      if (tool == null) return;
                      _run(context, () => controller.acceptLoanRequest(tool, request));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    tooltip: "Ablehnen",
                    onPressed: () {
                      final tool = toolFor(request.toolId);
                      if (tool == null) return;
                      _run(context, () => controller.rejectLoanRequest(tool, request));
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
        if (myOpenRequests.isNotEmpty) ...[
          Text("Deine offenen Anfragen", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final request in myOpenRequests)
            _RequestTile(
              request: request,
              tool: toolFor(request.toolId),
              trailing: TextButton(
                onPressed: () {
                  final tool = toolFor(request.toolId);
                  if (tool == null) return;
                  _run(context, () => controller.cancelLoanRequest(tool, request));
                },
                child: const Text("Zurückziehen"),
              ),
            ),
          const SizedBox(height: 16),
        ],
        if (activeLoans.isNotEmpty) ...[
          Text("Aktive Ausleihen", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final loan in activeLoans)
            _LoanTile(
              loan: loan,
              tool: toolFor(loan.toolId),
              isOwner: myPubkey == loan.ownerPubkey,
              onConfirmReturn: () {
                final tool = toolFor(loan.toolId);
                if (tool == null) return;
                _run(context, () => controller.confirmReturn(tool, loan));
              },
            ),
        ],
      ],
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request, required this.tool, required this.trailing});

  final LoanRequest request;
  final Tool? tool;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tool?.name ?? "Unbekanntes Werkzeug"),
        subtitle: Text("angefragt am ${_formatDate(request.requestedAt)}"),
        trailing: trailing,
      ),
    );
  }
}

class _LoanTile extends StatelessWidget {
  const _LoanTile({
    required this.loan,
    required this.tool,
    required this.isOwner,
    required this.onConfirmReturn,
  });

  final Loan loan;
  final Tool? tool;
  final bool isOwner;
  final VoidCallback onConfirmReturn;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tool?.name ?? "Unbekanntes Werkzeug"),
        subtitle: Text("seit ${_formatDate(loan.acceptedAt)} ausgeliehen"),
        trailing: isOwner
            ? FilledButton.tonal(onPressed: onConfirmReturn, child: const Text("Rückgabe"))
            : const Icon(Icons.hourglass_bottom),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  final local = dt.toLocal();
  return "${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')}.${local.year}";
}
