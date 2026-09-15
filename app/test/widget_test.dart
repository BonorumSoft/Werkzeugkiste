// Smoke-/Flow-Test für die Werkzeugkiste-App: Onboarding -> Community-Auswahl.
//
// Ersetzt den von `flutter create` erzeugten Standard-Zähler-Test, der zur
// generierten Demo-UI gehörte, die hier bereits durch die echte App-UI
// ersetzt wurde.

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:werkzeugkiste_app/application/database_providers.dart";
import "package:werkzeugkiste_app/infrastructure/database/app_database.dart";
import "package:werkzeugkiste_app/presentation/app.dart";

import "fakes.dart";

Widget _testApp() {
  return ProviderScope(
    overrides: [
      identityStoreProvider.overrideWithValue(FakeIdentityStore()),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.forTesting();
        ref.onDispose(db.close);
        return db;
      }),
    ],
    child: const WerkzeugkisteApp(),
  );
}

void main() {
  testWidgets("zeigt Onboarding, wenn noch keine Identität existiert", (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text("Willkommen bei der Werkzeugkiste"), findsOneWidget);
  });

  testWidgets("nach Onboarding erscheint die Community-Auswahl", (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "Alex");
    await tester.tap(find.text("Loslegen"));
    await tester.pumpAndSettle();

    expect(find.text("Deine Communities"), findsOneWidget);
    expect(find.textContaining("Noch keine Community"), findsOneWidget);
  });

  testWidgets("neue Community erstellen führt zur Werkzeug-Übersicht", (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "Alex");
    await tester.tap(find.text("Loslegen"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Neue Community"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "Nachbarschaft Musterstraße");
    await tester.tap(find.text("Erstellen"));
    await tester.pumpAndSettle();

    expect(find.text("Werkzeuge"), findsOneWidget);
    expect(find.textContaining("Noch keine Werkzeuge"), findsOneWidget);
  });
}
