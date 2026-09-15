# Phase 6 – Mutationstest-Verifikation

## Werkzeugentscheidung: eigener Runner statt pub.dev-Paket

Für Dart existiert ein Community-Paket `mutation_test` auf pub.dev. Diese
Sandbox kann jedoch nicht gegen pub.dev prüfen, ob eine bestimmte Version
existiert oder welches Konfigurationsformat sie erwartet – derselbe
Netzwerk-Proxy, der `storage.googleapis.com` blockiert (siehe
`pipeline/00_offene_fragen.md`), blockiert auch `pub.dev`:

```
< HTTP/1.1 403 Forbidden
< X-Proxy-Error: blocked-by-allowlist
```

Ein Griff ins Ungewisse (Paketversion + YAML-/Konfigurationsschema raten,
dann über echte CI-Läufe iterativ korrigieren) hätte denselben
Trial-and-Error-Zyklus erfordert wie in Phase 4 bei `trivy-action`, nur mit
einer zusätzlichen, dauerhaften externen Abhängigkeit als Ergebnis.
Stattdessen: `tool/mutation_test.py`, ein kleines, selbst geschriebenes,
rein string-basiertes Mutationstest-Skript ohne weitere Abhängigkeiten
(nur Python, auf `ubuntu-latest` vorinstalliert, und `dart test`).

## Vorgehen

1. Baseline: `dart test test/domain` muss grün sein.
2. Für jede von 10 definierten Mutationen: exakt einen eindeutigen
   String in einer Domain-Datei durch eine mutierte Variante ersetzen,
   Testsuite laufen lassen, Original-Datei danach IMMER wiederherstellen.
3. Mutant "getötet" = Testsuite schlägt mit der Mutation fehl (gewünscht).
   Mutant "überlebt" = Testsuite bleibt trotz Mutation grün (Testlücke).
4. Das Skript beendet sich mit Exit-Code 1, sobald auch nur ein Mutant
   überlebt – Mutationstests sind laut Abschnitt 40 ("~80% kritische
   Logik") ein Qualitätstor, kein optionaler Report.

## Vor der eigentlichen Mutation gefundene und geschlossene Testlücken

Beim Entwurf der Mutationen fielen zwei echte Lücken auf, die VOR den
eigentlichen Mutationstests geschlossen wurden (siehe Commit
`bedbf11` – bereits über echten CI-Lauf
[`34938415380`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34938415380)
verifiziert, beide Jobs grün, inkl. der neuen Tests):

1. **`lib/domain/community.dart` hatte keine eigene Testdatei.** Die Klasse
   wurde in Phase 4 implementiert, aber nie durch einen eigenen
   Rot-vor-Grün-Zyklus abgesichert – ein Verstoß gegen den in Phase 3/4
   etablierten Prozess, der erst beim systematischen Durchgehen aller
   Domain-Dateien für die Mutationsauswahl auffiel. Geschlossen durch
   `test/domain/community_test.dart` (5 Tests: `hasActiveMember` in allen
   drei Fällen, `withMemberRemoved`, `toJson`/`Member.toJson`).
2. **`Tool.isOwnedBy()` war nach dem Phase-5-Refactor ungetestet.** Die
   Methode wurde vor Phase 5 indirekt über `tool_service.dart`s
   `_assertOwner()` genutzt; nach der Umstellung auf die generische
   `_assertActor()`-Hilfsfunktion (Phase 5) ruft `tool_service.dart`
   `isOwnedBy()` nicht mehr auf. Die öffentliche Methode blieb bestehen
   (bewusst, siehe `reports/phase5_refactor.md`), hatte danach aber keine
   einzige direkte Testabdeckung mehr. Geschlossen durch zwei neue Tests in
   `test/domain/tool_state_machine_test.dart`.

## Die 10 Mutationen

| ID | Datei | Beschreibung | REQ-Bezug |
|---|---|---|---|
| MUT-01 | tool.dart | AVAILABLE→DELETED aus Tool-State-Machine entfernt | Abschnitt 10.2 |
| MUT-02 | loan_request.dart | PENDING→CANCELLED aus LoanRequest-State-Machine entfernt | Abschnitt 11.1 |
| MUT-03 | conflict_resolution.dart | `isAfter`→`isBefore` (Last-Writer-Wins invertiert) | Abschnitt 22 |
| MUT-04 | conflict_resolution.dart | Tiebreak-Richtung umgekehrt (`>=0`→`<=0`) | Abschnitt 22 |
| MUT-05 | tool_service.dart | `_assertActor`: `!=`→`==` (hebelt alle Berechtigungsprüfungen aus) | Abschnitt 10.1/33 |
| MUT-06 | tool_service.dart | Duplicate-Request-Guard (REQ-249) wird nie ausgelöst | Abschnitt 11.1 |
| MUT-07 | loan.dart | `returnedAt`↔`COMPLETED`-Kopplung invertiert | Abschnitt 12 |
| MUT-08 | community.dart | `hasActiveMember`: `active`→`removed` | Abschnitt 9 |
| MUT-09 | community.dart | `withMemberRemoved` setzt fälschlich `active` | Abschnitt 9 |
| MUT-10 | tool.dart | `isOwnedBy`: `==`→`!=` | Abschnitt 10.1 |

Jede Mutation ist im Skript mit exakter Vorher-/Nachher-Zeile hinterlegt
und wird vor der Ausführung auf eindeutiges Vorkommen (genau 1x im
Zieltext) geprüft, damit sich das Skript bei künftigen Refactorings
kontrolliert meldet statt an der falschen Stelle zu mutieren.

## CI-Integration und Status

Ein neuer Job `mutation-testing` (in `.github/workflows/`, Abhängigkeit
`needs: domain-tests`) führt `python3 tool/mutation_test.py` aus. Da ich
Workflow-Dateien unter `.github/workflows/` aus einer bewussten
Sicherheitsentscheidung heraus nicht selbst schreibe (dieser Pfad kann
beliebigen Code mit Repo-Secrets ausführen – dieselbe Regel galt bereits
in Phase 3/4 für `cli.yml`), liegt die aktualisierte Workflow-Datei als
`ci.yml.PLEASE-ADD-MANUALLY-TO-.github-workflows` bei und muss manuell
übernommen werden.

**Status zum Zeitpunkt dieses Reports:** Skript und die zugehörigen neuen
Tests (`community_test.dart`, `isOwnedBy`-Tests) sind bereits gepusht und
über einen echten grünen CI-Lauf verifiziert
([`34938415380`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34938415380)).
Der eigentliche `mutation-testing`-Job lief zu diesem Zeitpunkt noch NICHT,
da die Workflow-Datei die manuelle Übernahme durch den Auftraggeber
voraussetzt. Sobald das erfolgt ist, wird dieser Report um das tatsächliche
Ergebnis (Mutation Score, ggf. Nacharbeiten bei überlebenden Mutanten)
ergänzt – siehe TODO-Markierung unten.

**TODO (nach manueller CI-Aktivierung nachzutragen):** tatsächlicher
Mutation Score aus dem ersten `mutation-testing`-Lauf.
