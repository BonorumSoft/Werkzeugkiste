import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../application/community_controller.dart";
import "../application/identity_controller.dart";
import "../application/ui_state_providers.dart";
import "community/community_picker_screen.dart";
import "home_shell.dart";
import "onboarding_screen.dart";

/// Wurzel-Widget der Werkzeugkiste-App.
///
/// Aufbau (Lastenheft Abschnitt 36, UI-/Presentation-Schicht):
/// 1. Solange keine lokale Geräte-Identität existiert -> [OnboardingScreen].
/// 2. Danach: solange keine Community ausgewählt ist -> [CommunityPickerScreen].
/// 3. Danach: [HomeShell] mit der eigentlichen Werkzeug-/Leih-/Community-UI.
class WerkzeugkisteApp extends StatelessWidget {
  const WerkzeugkisteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Werkzeugkiste",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true, brightness: Brightness.dark),
      home: const _RootGate(),
    );
  }
}

class _RootGate extends ConsumerWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityAsync = ref.watch(identityControllerProvider);
    return identityAsync.when(
      data: (identity) {
        if (identity == null) {
          return const OnboardingScreen();
        }
        return const _CommunityGate();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text("Fehler: $err"))),
    );
  }
}

class _CommunityGate extends ConsumerWidget {
  const _CommunityGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedCommunityIdProvider);
    final communitiesAsync = ref.watch(communitiesProvider);

    return communitiesAsync.when(
      data: (communities) {
        final stillExists = selectedId != null && communities.any((c) => c.communityId == selectedId);
        if (stillExists) {
          return HomeShell(communityId: selectedId);
        }
        return const CommunityPickerScreen();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text("Fehler: $err"))),
    );
  }
}
