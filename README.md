# Werkzeugkiste

Community-Werkzeug-Verleih-App – privat, kostenlos, dezentral, offline-first.

Basis: `pipeline/lastenheft-werkzeug-verleih-app-v0.4.md` (Lastenheft v0.4).
Entwicklungsprozess: siehe Meta-Prompt in `pipeline/00_offene_fragen.md` und
die generierten Pipeline-Artefakte in `pipeline/`.

## Status

- ✅ Phase 0 – Setup
- ✅ Phase 1 – Requirements-Extraktion (420 REQ-IDs, `pipeline/01_requirements.json`)
- ✅ Phase 2 – Testfall-Ableitung (432 TC-IDs, vollständige Traceability, `pipeline/02_testcases.json`, `pipeline/03_traceability.md`)
- ✅ Phase 3 – Rot: Domain-Testsuite vor Implementierung, Fehlschlag über echten CI-Lauf verifiziert ([`34932430991`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34932430991), siehe `reports/phase3_red.md`)
- ✅ Phase 4 – Grün: Domain-Schicht (Tool/Loan/LoanRequest/Community, State-Machines, Konfliktauflösung, Events) implementiert, alle Unit-Tests über echten CI-Lauf grün verifiziert ([`34936624556`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34936624556), siehe `reports/phase4_iterationen.md`)
- ✅ Phase 5 – Refactor: Zustandsautomaten- und Berechtigungs-Duplikate entfernt, Verhaltensgleichheit über echten CI-Lauf verifiziert ([`34937749441`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34937749441), siehe `reports/phase5_refactor.md`)
- 🟡 Phase 6 – Mutationstests: eigener Runner (`tool/mutation_test.py`, 10 Mutationen) + 2 vorab geschlossene Testlücken über echten CI-Lauf verifiziert ([`34938415380`](https://github.com/BonorumSoft/Werkzeugkiste/actions/runs/34938415380)); CI-Job selbst wartet auf manuelle Übernahme von `ci.yml.PLEASE-ADD-MANUALLY-TO-.github-workflows` (siehe `reports/phase6_mutation.md`)
- ✅ Phase 7 – Dokumentation: alle 8 ADRs aus Abschnitt 47 formal dokumentiert (`docs/adr/`), Architekturdoku erweitert (`docs/ARCHITECTURE.md`)
- ✅ Phase 8 – Abschlussbericht (`reports/phase8_abschlussbericht.md`): vollständige, ehrliche Scope-Bilanz über alle 9 Phasen
- 🟡 Phase 9 – Deployment: Roadmap/Checkliste dokumentiert (`reports/phase9_deployment.md`), keine echte Bereitstellung möglich ohne Application-/Infrastructure-/UI-Schicht

**Offener manueller Schritt:** Für den vollständigen Abschluss von Phase 6
muss `ci.yml.PLEASE-ADD-MANUALLY-TO-.github-workflows` unter
`.github/workflows/` übernommen werden (ich schreibe Workflow-Dateien aus
Sicherheitsgründen nicht selbst). Danach liefert der neue
`mutation-testing`-Job den tatsächlichen Mutation Score.

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
