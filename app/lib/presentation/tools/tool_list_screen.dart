import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "../../application/loan_workflow_controller.dart";
import "tool_detail_screen.dart";
import "tool_edit_screen.dart";

class ToolListScreen extends ConsumerWidget {
  const ToolListScreen({super.key, required this.communityId});

  final String communityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsAsync = ref.watch(toolsForCommunityProvider(communityId));
    return Scaffold(
      body: toolsAsync.when(
        data: (tools) {
          final visible = tools.where((t) => t.status != ToolStatus.deleted).toList();
          if (visible.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Noch keine Werkzeuge in dieser Community. Füge das erste "
                  "über den Button unten rechts hinzu.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96, top: 8),
            itemCount: visible.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tool = visible[index];
              return ListTile(
                leading: CircleAvatar(child: Text(tool.name.isNotEmpty ? tool.name[0].toUpperCase() : "?")),
                title: Text(tool.name),
                subtitle: Text(tool.category),
                trailing: _StatusChip(status: tool.status),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ToolDetailScreen(toolId: tool.toolId, communityId: communityId)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Fehler: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ToolEditScreen(communityId: communityId)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ToolStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ToolStatus.available => ("verfügbar", Colors.green),
      ToolStatus.requested => ("angefragt", Colors.orange),
      ToolStatus.loaned => ("verliehen", Colors.blueGrey),
      ToolStatus.deleted => ("gelöscht", Colors.red),
    };
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }
}
