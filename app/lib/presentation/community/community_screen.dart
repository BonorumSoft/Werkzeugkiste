import "package:flutter/material.dart";
import "package:flutter/services.dart" show Clipboard, ClipboardData;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/community.dart";
import "package:werkzeugkiste/domain/exceptions.dart";

import "../../application/community_controller.dart";
import "../../application/identity_controller.dart";
import "../utils/list_ext.dart";

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key, required this.communityId});

  final String communityId;

  Future<void> _createInvite(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(communityControllerProvider).createInvite(communityId);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Einladung erstellt"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Teile dieses Token mit der eingeladenen Person. Es wird nur jetzt angezeigt:"),
              const SizedBox(height: 12),
              SelectableText(
                result.plaintextToken,
                style: const TextStyle(fontFamily: "monospace", fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Gültig bis ${result.invite.expiresAt.toLocal()}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Hinweis: Die automatische Verteilung an andere Geräte über "
                "Nostr (ADR-01/02/08) ist noch nicht implementiert – das "
                "Token muss aktuell manuell (z. B. per Messenger) geteilt "
                "werden.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: result.plaintextToken));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("In Zwischenablage kopiert.")),
                );
              },
              child: const Text("Kopieren"),
            ),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text("Fertig")),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        final message = e is DomainException ? e.message : "$e";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(communitiesProvider);
    final myPubkey = ref.watch(identityControllerProvider).valueOrNull?.pubkey;

    return Scaffold(
      body: communitiesAsync.when(
        data: (communities) {
          final community = communities.firstWhereOrNull((c) => c.communityId == communityId);
          if (community == null) {
            return const Center(child: Text("Community nicht gefunden."));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(community.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text("Mitglieder", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final member in community.members) _MemberTile(member: member, isMe: member.pubkey == myPubkey),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text("Einladung erstellen"),
                onPressed: () => _createInvite(context, ref),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Fehler: $err")),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.isMe});

  final Member member;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final removed = member.status == MembershipStatus.removed;
    return ListTile(
      leading: CircleAvatar(child: Text(member.displayName.isNotEmpty ? member.displayName[0].toUpperCase() : "?")),
      title: Text(isMe ? "${member.displayName} (du)" : member.displayName),
      subtitle: Text(removed ? "entfernt" : "aktiv"),
      trailing: removed ? const Icon(Icons.block, color: Colors.grey) : null,
    );
  }
}
