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
- ⏳ Phase 6–9 – ausstehend (Mutation-Verifikation, weitere Dokumentation/ADRs, Abschlussbericht, Deployment)

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
