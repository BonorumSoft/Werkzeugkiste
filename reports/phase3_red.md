# Phase 3 – Rot: Nachweis

**Commit (Tests, ohne Implementierung):** `838192f` – "Phase 3 (rot): Domain-Testsuite vor Implementierung"

Da diese Pipeline in einer Sandbox ohne Dart/Flutter-SDK-Zugriff läuft (siehe
`pipeline/00_offene_fragen.md`, Abschnitt „Umgebungs-Hinweis"), wurde der
Rot-Nachweis nicht lokal, sondern über echte GitHub-Actions-CI-Läufe auf
`BonorumSoft/Werkzeugkiste` erbracht.

## Nachweis

**Lauf:** [`34932430991`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34932430991)
(Commit `a1963b2e`, zu diesem Zeitpunkt existierte `lib/domain/` noch nicht)

Job „Domain-Schicht – Format/Analyze/Test/Coverage" schlägt beim Schritt
„Static analysis / Linting" fehl mit u. a.:

```
test/domain/conflict_resolution_test.dart#L7
Target of URI doesn't exist: 'package:werkzeugkiste/domain/conflict_resolution.dart'.

test/domain/conflict_resolution_test.dart#L8
Target of URI doesn't exist: 'package:werkzeugkiste/domain/tool.dart'.

test/domain/conflict_resolution_test.dart#L19,27,35,36,37
The function 'resolveConflict' isn't defined.

test/domain/events_test.dart#L4
Target of URI doesn't exist: 'package:werkzeugkiste/domain/events.dart'.

test/domain/events_test.dart#L9
The function 'ToolCreated' isn't defined.
```

Das ist der erwartete Rot-Zustand: alle Testfälle referenzieren
Domain-Klassen/-Funktionen, die zu diesem Zeitpunkt bewusst noch nicht
existieren (Tool, Loan, LoanRequest, Community, conflict_resolution,
tool_service, events – siehe `lib/domain/`). Der CI-Lauf kann an dieser
Stelle nicht kompilieren, geschweige denn Tests grün melden – ein Test, der
hier fälschlich grün wäre, wäre nach den globalen Regeln des Meta-Prompts
(Regel 5) ungültig formuliert. Das ist hier nicht der Fall: alle Fehler sind
Kompilierfehler wegen fehlender Implementierung, keine falsch-positiven
Testergebnisse.

## Nebenbefunde in diesem und vorherigen Läufen (Tooling, nicht Domain-Logik)

Auf dem Weg zu diesem sauberen Rot-Nachweis mussten drei reine
CI-Konfigurationsfehler behoben werden (siehe Git-Historie und
`reports/phase4_iterationen.md`):

1. YAML-Syntaxfehler in `cli.yml` (ungeschützter Doppelpunkt in einem
   Step-Namen) – erster Lauf (`34930383384`) konnte gar keine Jobs starten.
2. `aquasecurity/trivy-action@0.29.0` / `@v0.30.0` – ungültige bzw. intern
   kaputte Versionsreferenz (referenzierte einen nicht existenten
   `setup-trivy`-Tag) – behoben auf `@v0.36.0` (pinnt intern per Commit-Hash).
3. `dart format --set-exit-if-changed` schlug initial fehl, da der
   Code ohne lokal verfügbares SDK verfasst wurde – vorübergehend als
   `continue-on-error: true` markiert (siehe Kommentar in `cli.yml`).

Diese drei Punkte betreffen ausschließlich die CI-Pipeline selbst, nicht die
Domain-Logik, und sind in `pipeline/00_offene_fragen.md` nicht gesondert
aufgeführt, da sie zwischenzeitlich bereits behoben wurden.
