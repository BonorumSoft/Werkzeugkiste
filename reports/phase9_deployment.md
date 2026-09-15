# Phase 9 – Deployment-Vorbereitung

**Wichtiger Hinweis vorab:** Diese Phase kann in diesem Projektstadium
keine tatsächliche Bereitstellung (App-Store-Release, Produktivbetrieb)
durchführen oder auch nur vorbereiten im Sinne von "fertigem
Build-Artefakt". Es existiert bislang ausschließlich die Domain-Schicht
(`lib/domain/`) – keine Flutter-UI, keine Persistenz, keine
Nostr-Anbindung (siehe `reports/phase8_abschlussbericht.md`, Abschnitt 3).
Ein `flutter build ios`/`flutter build appbundle` ist ohne diese Schichten
nicht sinnvoll ausführbar. Diese Phase liefert daher eine **Roadmap und
Checkliste**, keine ausgeführte Bereitstellung.

## 1. Was fehlt bis zu einem deploybaren MVP

In Reihenfolge der wahrscheinlichen Abhängigkeiten:

1. **ADR-Entscheidungen einholen** (`docs/adr/`) – insbesondere ADR-07
   (lokale DB), ADR-01 (Nostr-Event-Modell) und ADR-02
   (Community-Verschlüsselung), da UI und Infrastructure direkt davon
   abhängen.
2. **Infrastructure-Schicht**: Drift/SQLite-Anbindung (oder Isar, je nach
   ADR-07), Nostr-Client-Bindung (Signieren/Verifizieren, Relay-Kommunikation),
   Blossom-Client für Fotos (ADR-05).
3. **Application-/State-Schicht**: verbindet UI-Events mit den bereits
   vorhandenen `tool_service.dart`-Funktionen, verwaltet Sitzungszustand,
   löst `resolveConflict()` bei eingehenden Sync-Events aus.
4. **UI-Schicht** (Flutter): Bildschirme für Werkzeugliste, Anfrage-Flow,
   Community-Verwaltung, Einstellungen – abgeleitet aus den 32
   Widget-Testfällen in `pipeline/02_testcases.json`.
5. **Sicherheits-/Infra-Härtung**: die 73 Security-Testfälle (v. a.
   E2E-Verschlüsselung, Schlüsselverwaltung) müssen dann tatsächlich
   gegen echten Code laufen, nicht nur gegen die Domain-Schicht.

## 2. CI/CD-Erweiterungsplan

Aktueller Stand (`.github/workflows/`): Formatting, Analyze, Import-Guard,
Unit-Tests mit Coverage, Trivy-Secret-Scan, (vorbereitet, aber noch nicht
aktiv:) Mutationstests. Für einen echten Release-Build fehlen:

- **Build-Jobs** für Android (`flutter build appbundle`) und iOS
  (`flutter build ipa`, benötigt macOS-Runner und Apple-Signing-Zertifikate
  als Secrets).
- **Codesigning-Verwaltung**: Android Keystore und Apple
  Provisioning-Profile/Zertifikate als verschlüsselte GitHub-Secrets, NIE
  im Repository (der bereits vorhandene Trivy-Secret-Scan-Job dient hier
  als zusätzliches Sicherheitsnetz gegen versehentliches Einchecken).
- **Store-Deployment-Jobs**: z. B. `fastlane` oder die offiziellen
  GitHub Actions für Google Play Console / App Store Connect, ausgelöst
  über Git-Tags (siehe Versionierung unten), nicht bei jedem Push auf
  `main`.
- **Staged Rollouts**: Google Play unterstützt prozentuale Rollouts nativ;
  für iOS empfiehlt sich TestFlight als verpflichtende Zwischenstufe vor
  jedem produktiven Release.

## 3. Versionierungsstrategie (Vorschlag)

- **App-Version**: Semantic Versioning (`MAJOR.MINOR.PATCH`), getriggert
  über Git-Tags (`v0.1.0` für den ersten MVP-Release). CI-Build-Jobs
  reagieren auf `push: tags: ['v*']`, nicht auf jeden `main`-Push.
- **`schema_version`** (bereits in `Tool`, `LoanRequest`, `Loan`,
  `DomainEvent` vorhanden, siehe `lib/domain/`): monoton steigender
  Integer pro Entität, wie in `pipeline/00_offene_fragen.md` Punkt 4
  angenommen. Migration bei Sprüngen ist Teil von ADR-07 (lokale DB) und
  noch nicht implementiert – ein Migrationskonzept sollte VOR dem ersten
  produktiven Release stehen, da eine dezentrale App ohne zentralen Server
  keine serverseitige Datenmigration nachträglich erzwingen kann.
- **Nostr-Event-Kompatibilität**: Da Events dauerhaft auf Relays verbleiben
  (Abschnitt 38), muss jede künftige Änderung am Event-Schema
  abwärtskompatibel sein oder eine explizite Versionsmigration im
  Event-Envelope vorsehen (hängt an ADR-01).

## 4. Store-Readiness-Checkliste (Ausblick, nicht abgearbeitet)

- [ ] App-Icons, Screenshots, Store-Listing-Texte
- [ ] Datenschutzerklärung (relevant: dezentrale Architektur ohne
      zentralen Server – Formulierung erfordert sorgfältige Abstimmung
      mit Apple/Google-Anforderungen zu "wo werden Daten gespeichert")
- [ ] Altersfreigabe/Content-Rating
- [ ] Apple Developer Program- und Google Play Console-Account
- [ ] TestFlight-/Internal-Testing-Gruppe für Beta-Phase vor Vollrelease

## 5. Fazit

Phase 9 im engeren Sinne (tatsächliche Bereitstellung) ist zum jetzigen
Zeitpunkt nicht sinnvoll durchführbar, da die dafür nötigen Schichten
(Application/Infrastructure/UI) außerhalb des in dieser Pipeline
gewählten Scopes liegen (siehe `reports/phase8_abschlussbericht.md`).
Diese Datei dokumentiert stattdessen den Weg dorthin, damit bei Fortsetzung
des Projekts (nächster Schritt: ADR-Entscheidungen durch den Auftraggeber,
siehe `docs/adr/`) keine Deployment-relevante Überlegung verloren geht.
