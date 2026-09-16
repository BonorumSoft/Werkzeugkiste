import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/community.dart";

import "../../application/community_controller.dart";
import "../../application/ui_state_providers.dart";

class CommunityPickerScreen extends ConsumerWidget {
  const CommunityPickerScreen({super.key});

  Future<void> _createCommunity(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Neue Community"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: "Name der Community"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Erstellen"),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final community = await ref.read(communityControllerProvider).createCommunity(name);
    ref.read(selectedCommunityIdProvider.notifier).state = community.communityId;
  }

  Future<void> _redeemInvite(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final token = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Einladung einlösen"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: "Einladungs-Token"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Einlösen"),
          ),
        ],
      ),
    );
    if (token == null || token.isEmpty) return;
    try {
      final invite = await ref.read(communityControllerProvider).redeemInvite(token);
      ref.read(selectedCommunityIdProvider.notifier).state = invite.communityId;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Einladung erfolgreich eingelöst.")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(communitiesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Deine Communities")),
      body: communitiesAsync.when(
        data: (communities) => _CommunityList(
          communities: communities,
          onSelect: (c) => ref.read(selectedCommunityIdProvider.notifier).state = c.communityId,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Fehler: $err")),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: "redeem",
            onPressed: () => _redeemInvite(context, ref),
            icon: const Icon(Icons.mail_outline),
            label: const Text("Einlösen"),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            heroTag: "create",
            onPressed: () => _createCommunity(context, ref),
            icon: const Icon(Icons.add),
            label: const Text("Neue Community"),
          ),
        ],
      ),
    );
  }
}

class _CommunityList extends StatelessWidget {
  const _CommunityList({required this.communities, required this.onSelect});

  final List<Community> communities;
  final ValueChanged<Community> onSelect;

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            "Noch keine Community. Erstelle eine neue oder löse eine "
            "erhaltene Einladung ein.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: communities.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final community = communities[index];
        final activeMembers = community.members.where((m) => m.status == MembershipStatus.active).length;
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.groups_outlined)),
          title: Text(community.name),
          subtitle: Text("$activeMembers aktive Mitglieder"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onSelect(community),
        );
      },
    );
  }
}
