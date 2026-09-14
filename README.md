# Werkzeugkiste

Community-Werkzeug-Verleih-App – privat, kostenlos, dezentral, offline-first.

Basis: `pipeline/lastenheft-werkzeug-verleih-app-v0.4.md` (Lastenheft v0.4).
Entwicklungsprozess: siehe Meta-Prompt in `pipeline/00_offene_fragen.md` und
die generierten Pipeline-Artefakte in `pipeline/`.

## Status

- ✅ Phase 0 – Setup
- ✅ Phase 1 – Requirements-Extraktion (420 REQ-IDs, `pipeline/01_requirements.json`)
- ✅ Phase 2 – Testfall-Ableitung (432 TC-IDs, vollständige Traceability, `pipeline/02_testcases.json`, `pipeline/03_traceability.md`)
- 🚧 Phase 3/4 – Domain-Schicht (Tool/Loan/LoanRequest/Community, State-Machines, Konfliktauflösung, Events) mit Unit-Tests. CI läuft auf GitHub Actions (`.github/workflows/ci.yml`) – siehe `reports/`.
- ⏳ Phase 5–9 – ausstehend (Refactor, Mutation-Verifikation, Dokumentation, Abschlussbericht, Deployment)

## Projektstruktur

```text
lib/domain/     – frameworkfreie Domain-Schicht (Abschnitt 36)
test/domain/    – Unit-Tests der Domain-Schicht
pipeline/       – Requirements, Testfälle, Traceability, offene Fragen
docs/           – Architekturdokumentation
reports/        – Testberichte, Mutation-Reports, Abschlussbericht
```

## Lokale Entwicklung

```bash
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze
dart test
```

Hinweis: Diese Tests wurden bislang ausschließlich über GitHub Actions CI
verifiziert (nicht in einer lokalen Sandbox), siehe `reports/phase3_red.md`
und `reports/phase4_iterationen.md` für die jeweiligen CI-Run-Links.
