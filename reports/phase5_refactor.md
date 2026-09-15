# Phase 5 – Refactor

Ziel dieser Phase: Duplikate und Wiederholungen in der Domain-Schicht
beseitigen, OHNE Verhalten, öffentliche Signaturen oder Testergebnisse zu
verändern (reines Refactoring im klassischen Sinn: Rot bleibt rot, Grün
bleibt grün – siehe verifizierten CI-Lauf unten).

## Gefundene Duplikate und Maßnahmen

**1. Zustandsautomaten-Muster (Tool-Status / LoanRequest-Status)**

`lib/domain/tool.dart` und `lib/domain/loan_request.dart` pflegten
unabhängig voneinander exakt dasselbe Muster: eine Übergangs-Map
(`Map<Status, Set<Status>>`) plus ein `isValidXTransition`/
`assertValidXTransition`-Funktionspaar, das nur nachschlägt bzw. bei
Nichtgefundenem `InvalidStateTransition` wirft.

Neu: `lib/domain/state_machine.dart` mit den generischen Funktionen
`isValidTransition<S>(...)` und `assertValidTransition<S>(...)`.
`tool.dart` und `loan_request.dart` delegieren jetzt an diesen Baustein.

Die öffentlichen Funktionen `isValidToolTransition`,
`assertValidToolTransition`, `isValidLoanRequestTransition`,
`assertValidLoanRequestTransition` behalten exakt dieselbe Signatur und
dasselbe Verhalten – bestehende Tests (u. a.
`test/domain/tool_state_machine_test.dart`, das diese Funktionen direkt
aufruft) mussten nicht angepasst werden.

**2. Berechtigungsprüfung in `tool_service.dart`**

Das Muster "Aktor muss mit einem bestimmten Pubkey übereinstimmen, sonst
`PermissionDenied` werfen" kam fünfmal wiederholt vor (Eigentümer
bearbeiten, Eigentümer löschen, Eigentümer bestätigt Anfrage, Eigentümer
lehnt ab, Anfragender zieht zurück, Eigentümer bestätigt Rückgabe – de
facto sechsmal, davon einmal über die vorherige `_assertOwner`-Hilfsfunktion,
die nur den Tool-Eigentümer-Spezialfall abdeckte).

Neu: eine einzige private Hilfsfunktion `_assertActor(actual, expected,
{action, roleLabel})` in `tool_service.dart`, die alle sechs Fälle abdeckt
(inkl. des vorherigen Sonderfalls `_assertOwner`, der entfernt wurde).

## Nicht verändert (bewusst)

- `lib/domain/conflict_resolution.dart` und `lib/domain/events.dart` wurden
  durchgesehen, enthielten aber keine nennenswerten Duplikate – die
  `DomainEvent`-Subklassen nutzen bereits Darts `super`-Parameter-Kurzform,
  eine weitere Abstraktion (z. B. Code-Generierung) hätte hier mehr
  Komplexität hinzugefügt als Duplikate entfernt.
- Öffentliche Methode `Tool.isOwnedBy()` bleibt bestehen, auch wenn sie nach
  dem `tool_service.dart`-Refactor intern nicht mehr aufgerufen wird – sie
  ist Teil der öffentlichen Domain-API (z. B. für spätere
  Application-/UI-Schicht-Prüfungen "kann dieser Nutzer bearbeiten?") und
  kein toter Code im Sinne des Dart-Analyzers (`unused_element` gilt nur für
  private Member).

## Verifikation

Da diese Sandbox kein Dart-SDK ausführen kann (siehe
`pipeline/00_offene_fragen.md`), wurde die Verhaltensgleichheit wie in
Phase 3/4 über einen echten GitHub-Actions-CI-Lauf nachgewiesen, nicht durch
lokale Ausführung.

**Lauf:** [`34937749441`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34937749441)
(Commit `a225494`, "Phase 5 (Refactor): Zustandsautomaten- und
Berechtigungs-Duplikate entfernen")

Beide Jobs vollständig grün, inkl. „Unit Tests mit Coverage" – ohne dass
auch nur eine Testdatei angefasst wurde. Das ist der Nachweis, dass das
Refactoring rein strukturell war und keine Verhaltensänderung eingeführt
hat.
