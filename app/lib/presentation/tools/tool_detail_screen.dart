import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "../../application/identity_controller.dart";
import "../../application/loan_workflow_controller.dart";
import "../utils/list_ext.dart";
import "tool_edit_screen.dart";

class ToolDetailScreen extends ConsumerWidget {
  const ToolDetailScreen({super.key, required this.toolId, required this.communityId});

  final String toolId;
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

    return Scaffold(
      appBar: AppBar(title: const Text("Werkzeug")),
      body: toolsAsync.when(
        data: (tools) {
          final tool = tools.firstWhereOrNull((t) => t.toolId == toolId);
          if (tool == null) {
            return const Center(child: Text("Werkzeug nicht mehr verfügbar."));
          }
          final isOwner = myPubkey != null && tool.isOwnedBy(myPubkey);
          final pendingRequest = requestsAsync.valueOrNull?.firstWhereOrNull(
            (r) => r.toolId == toolId && r.status == LoanRequestStatus.pending,
          );
          final activeLoan = loansAsync.valueOrNull?.firstWhereOrNull(
            (l) => l.toolId == toolId && l.status == LoanStatus.active,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(tool.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(tool.category, style: Theme.of(context).textTheme.bodyMedium),
              if (tool.model != null) ...[
                const SizedBox(height: 8),
                Text("Modell: ${tool.model}"),
              ],
              if (tool.condition != null) ...[
                const SizedBox(height: 8),
                Text("Zustand: ${tool.condition}"),
              ],
              if (tool.description != null) ...[
                const SizedBox(height: 12),
                Text(tool.description!),
              ],
              const SizedBox(height: 24),
              if (tool.status == ToolStatus.available && !isOwner)
                FilledButton.icon(
                  icon: const Icon(Icons.front_hand_outlined),
                  label: const Text("Ausleihe anfragen"),
                  onPressed: () => _run(context, () => controller.requestLoan(tool)),
                ),
              if (tool.status == ToolStatus.available && isOwner) ...[
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text("Bearbeiten"),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ToolEditScreen(communityId: communityId, tool: tool)),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Löschen"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () => _run(context, () async {
                    await controller.deleteTool(tool);
                    if (context.mounted) Navigator.of(context).pop();
                  }),
                ),
              ],
              if (pendingRequest != null) ...[
                const Divider(height: 32),
                Text("Offene Leihanfrage", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (isOwner) ...[
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _run(context, () => controller.acceptLoanRequest(tool, pendingRequest)),
                          child: const Text("Annehmen"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _run(context, () => controller.rejectLoanRequest(tool, pendingRequest)),
                          child: const Text("Ablehnen"),
                        ),
                      ),
                    ],
                  ),
                ] else if (myPubkey == pendingRequest.requesterPubkey) ...[
                  OutlinedButton(
                    onPressed: () => _run(context, () => controller.cancelLoanRequest(tool, pendingRequest)),
                    child: const Text("Anfrage zurückziehen"),
                  ),
                ],
              ],
              if (activeLoan != null && isOwner) ...[
                const Divider(height: 32),
                Text("Aktive Ausleihe", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Rückgabe bestätigen"),
                  onPressed: () => _run(context, () => controller.confirmReturn(tool, activeLoan)),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Fehler: $err")),
      ),
    );
  }
}
