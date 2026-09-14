# Offene Fragen / Annahmen / Umgebungs-Hinweise

Diese Datei wird gemäß den globalen Regeln des Meta-Prompts geführt: jede Abweichung, Lücke oder Mehrdeutigkeit im Lastenheft wird hier dokumentiert statt stillschweigend interpretiert.

## Umgebungs-Hinweis (Phase 0, 2026-09-14)

Diese Pipeline läuft in einer isolierten Cloud-Sandbox ohne freien Internetzugang (Egress-Allowlist beschränkt auf u. a. npm/PyPI/crates.io/Go-Proxy). Ein Download des Flutter- bzw. Dart-SDK (z. B. von `storage.googleapis.com`) ist in dieser Sandbox **nicht möglich** (Verbindung wird vom Proxy mit HTTP 403 abgelehnt). Das bedeutet konkret für Phase 3–6 des Meta-Prompts:

- Es kann in dieser Sandbox **kein** `flutter`/`dart test` ausgeführt werden.
- Der in Phase 3–6 geforderte Nachweis „Test schlägt zuerst fehl, dann grün, dann Mutation schlägt fehl" kann hier **nicht automatisiert verifiziert** werden, solange kein Dart/Flutter-Interpreter verfügbar ist.
- Alternative: Über die Geräte-Bridge zu Tjorbens verbundenem Mac (`macbook-air-von-tjorben-local`) könnte ein echtes Flutter-Setup (z. B. via Homebrew) erfolgen und dort die eigentliche TDD-Pipeline (Phase 3–6) ausgeführt werden. Das erfordert: (a) Freigabe eines Projektordners auf dem Mac, (b) Installation von Flutter/Xcode-Commandline-Tools dort (größerer Download, einmalig), (c) Ausführung der Tests dort statt in der Cloud-Sandbox.
- **Diese Entscheidung wurde an Tjorben zurückgespiegelt und ist noch offen** (siehe Chat-Rückmeldung). Bis zur Entscheidung wurden Phase 0–2 (umgebungsunabhängige Analysearbeit) vollständig durchgeführt; Phase 3+ ist pausiert.

## Prozessuale Annahmen (Phase 1)

1. **Technischer Ziel-Stack**: Abschnitt 35 nennt Flutter/Dart, Riverpod, Drift/SQLite oder Isar, sowie eine Nostr-kompatible Dart-Bibliothek nur als *Kandidaten*, die laut Lastenheft „grundsätzlich noch durch ADRs zu bestätigen" sind (ADR-07). Annahme für diese Pipeline: Flutter/Dart wird als Zielstack übernommen (wie im beigefügten Meta-Prompt explizit vorgegeben), Drift/SQLite wird gegenüber Isar bevorzugt (verbreiteter, SQL-basiert, gute Encryption-at-Rest-Unterstützung über SQLCipher). Diese Annahme ersetzt **nicht** die in ADR-07 geforderte formale Entscheidung.
2. **Konfliktauflösungsregeln (ADR-04)**: Das Lastenheft verweist mehrfach auf deterministische Konfliktregeln, spezifiziert diese aber nicht (Abschnitt 22, 47). Für die Domain-Implementierung wird – bis ADR-04 vorliegt – testweise eine plausible Default-Regel angenommen: „Last-Writer-Wins nach `updated_at`, bei Zustandsübergängen mit Vorrang für den Status mit höherer Priorität in der State-Machine (z. B. LOANED schlägt AVAILABLE bei gleichzeitiger widersprüchlicher Änderung), Tie-Break über lexikographischen Vergleich der Event-ID." Dies ist eine **Annahme**, keine Entscheidung des Auftraggebers, und muss vor Produktivsetzung durch ADR-04 ersetzt/bestätigt werden.
3. **Nostr-Event-Mapping (ADR-01)**: Für Testzwecke wird angenommen, dass jedes fachliche Event (`ToolCreated` etc.) als NIP-44-verschlüsselter, signierter Nostr-Event mit einem Custom-Kind-Range (z. B. 30000er „addressable events") abgebildet wird. Dies ist eine Arbeitsannahme für die Domain-/Infrastruktur-Grenze, keine endgültige ADR-01-Entscheidung.
4. **Schema-Versionierung**: `schema_version` wird als Integer ab `1` angenommen, monoton steigend bei inkompatiblen Änderungen.
5. **Guard-Test-Interpretation**: Für alle in Abschnitt 4 gelisteten Ausschlüsse sowie die in Abschnitt 12 explizit verneinten Felder (`lent_at`, `expected_return_at`) werden Guard-Tests als Kombination aus (a) Datenmodell-Introspektion (Feld existiert nicht) und (b) Verhaltenstest (Aktion ist über die Domain-API nicht auslösbar) verstanden.

## Offene Punkte aus dem Lastenheft selbst (Abschnitt 47, zur Nachverfolgung)

Alle acht ADRs (ADR-01 bis ADR-08) sind laut Lastenheft vor der Implementierung zu entscheiden. Sie sind in `01_requirements.json` als eigene Requirements (REQ mit Quelle „47") erfasst, damit sie in der Traceability-Matrix nicht verloren gehen, auch wenn sie keine klassischen funktionalen Testfälle im engeren Sinne ergeben.

## Erweiterung des Testfall-Typs (Phase 2)

Der Meta-Prompt nennt als `typ`-Werte für Testfälle: Unit / Widget / Integration / Security / Guard. Für Requirements, die keine unmittelbar im Code ausführbaren Verhaltenstests sind, sondern Governance-/Prozessvorgaben (offene ADRs aus Abschnitt 47, CI/CD-Pipeline-Schritte aus Abschnitt 41, Compliance-Prüfpunkte aus Abschnitt 45, Architektur-Leitplanken aus Abschnitt 35/36), wurde der zusätzliche Typ **„Prozess"** eingeführt (125 von 432 Testfällen). Diese „Testfälle" sind als Prüfpunkte für Phase 7/8/9 (Dokumentation, CI-Konfiguration, Deployment-Checkliste) zu verstehen, nicht als `flutter test`-Fälle. Die Traceability-Matrix bleibt dadurch vollständig (kein Requirement ohne Testfall), ohne die Kategorien des Meta-Prompts zu verletzen.

## Widersprüche / Mehrdeutigkeiten im Lastenheft

Keine gefunden. Die in den „Änderungen gegenüber v0.3" beschriebenen Korrekturen (Abschnitt 20 Rückweg aus CONFLICT, Abschnitt 48 Relay-Betreiber-Korrektur) wurden bei der Requirements-Extraktion berücksichtigt.
