import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../application/ui_state_providers.dart";
import "community/community_screen.dart";
import "loans/loans_screen.dart";
import "tools/tool_list_screen.dart";

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.communityId});

  final String communityId;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const _titles = ["Werkzeuge", "Anfragen & Ausleihen", "Community"];

  @override
  Widget build(BuildContext context) {
    final screens = [
      ToolListScreen(communityId: widget.communityId),
      LoansScreen(communityId: widget.communityId),
      CommunityScreen(communityId: widget.communityId),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: "Community wechseln",
            onPressed: () => ref.read(selectedCommunityIdProvider.notifier).state = null,
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.handyman_outlined), label: "Werkzeuge"),
          NavigationDestination(icon: Icon(Icons.swap_horizontal_circle_outlined), label: "Leihen"),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: "Community"),
        ],
      ),
    );
  }
}
