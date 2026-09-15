# ADR-07 – Lokale Datenbank

**Status:** Vorschlag (Claude, September 2026) – wartet auf Bestätigung
durch den Auftraggeber. Bestätigt/präzisiert die bisherige
Arbeitsannahme aus Phase 1.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Drift/SQLite
vs. Isar, Verschlüsselung lokaler Daten, Migrationen.

## Vorschlag

**Drift/SQLite** (gegenüber Isar bestätigt): verbreiteter, SQL-basiert,
etablierte SQLCipher-Integration für Encryption-at-Rest, gutes Tooling
für Schema-Migrationen. Isar bietet zwar potenziell bessere
Rohperformance für sehr große Objektmengen, was für den erwarteten
Datenumfang dieser App (Werkzeuge/Anfragen/Ausleihen einer lokalen
Community, keine Big-Data-Größenordnung) keinen relevanten Vorteil
bringt und dafür ein weniger verbreitetes Ökosystem hat.

**Verschlüsselung:** SQLCipher mit einem eigenständigen, zufällig
erzeugten 256-Bit-Passwort, das bei Erstinstallation generiert und in
der Plattform-Secure-Storage (iOS Keychain / Android Keystore) abgelegt
wird – **bewusst NICHT vom Nostr-Schlüssel (nsec) abgeleitet.**
Trennung der beiden Geheimnisse, damit z. B. eine künftige Rotation des
lokalen DB-Passworts (etwa bei Verdacht auf Kompromittierung der lokalen
DB-Datei) nicht die Nostr-Identität invalidiert, und umgekehrt ein
Schlüsselwechsel gemäß ADR-06 nicht zwingend eine DB-Neuverschlüsselung
erfordert.

**Migrationen:** Drifts eingebaute `MigrationStrategy`, versioniert über
das übliche Drift-Schema-Versionsfeld. Wichtig: **zwei unterschiedliche
"Versions"-Konzepte klar auseinanderhalten**, die leicht verwechselt
werden können:
1. Die Drift-Datenbankschema-Version (lokale Tabellenstruktur dieses
   einen Geräts).
2. Das bereits vorhandene `schemaVersion`-Feld auf den Domain-Entitäten
   selbst (`Tool`, `LoanRequest`, `Loan`, `DomainEvent` – Wire-Format-
   Version für Sync/Events zwischen Geräten, siehe
   `pipeline/00_offene_fragen.md` Punkt 4).

Diese beiden Versionsnummern werden unabhängig voneinander hochgezählt
und dürfen nicht synchron gehalten oder verwechselt werden: ein
App-Update kann z. B. die lokale Tabellenstruktur ändern, ohne dass sich
am Sync-Wire-Format etwas ändert, und umgekehrt.

## Offene Punkte (auch nach diesem Vorschlag)

- Konkrete Migrationsschritte existieren naturgemäß erst, sobald die
  erste reale Schemaänderung ansteht – reine Prozessfestlegung hier,
  kein konkreter Migrationsplan nötig, solange es nur einen
  Schema-Stand gibt.

## Konsequenz für den Code

Kein Domain-Layer-Code betroffen (Abschnitt 36: Domain bleibt
persistenzfrei, bereits durch den CI-Import-Guard hart durchgesetzt).
Betrifft ausschließlich die noch nicht implementierte Infrastructure-
Schicht.
