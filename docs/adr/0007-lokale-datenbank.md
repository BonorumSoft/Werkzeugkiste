# ADR-07 – Lokale Datenbank

**Status:** Arbeitsannahme getroffen (Phase 1), NICHT final durch den
Auftraggeber bestätigt, NICHT implementiert.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Drift/SQLite vs.
Isar, Verschlüsselung lokaler Daten, Migrationen. Abschnitt 35 nennt
Drift/SQLite und Isar nur als *Kandidaten*, die laut Lastenheft
„grundsätzlich noch durch ADRs zu bestätigen" sind.

## Bisherige Arbeitsannahme (siehe `pipeline/00_offene_fragen.md`, Punkt 1)

Drift/SQLite wird gegenüber Isar bevorzugt: verbreiteter, SQL-basiert,
gute Encryption-at-Rest-Unterstützung über SQLCipher (relevant für
Abschnitt 23/44.4 „lokale Daten sind verschlüsselt zu speichern"). Diese
Annahme wurde für die Requirements-/Testfall-Ableitung (Phase 1/2)
übernommen, ersetzt aber ausdrücklich NICHT die in ADR-07 geforderte
formale Entscheidung.

## Stand der Implementierung

Nicht Teil des in Phase 3/4 gewählten Domain-Scopes – die Domain-Schicht
ist laut Abschnitt 36 explizit persistenzfrei (kein SQLite-, Drift- oder
Isar-Import in `lib/domain/`, hart durchgesetzt durch den
Import-Guard-Schritt in der CI, siehe `.github/workflows/`). Diese ADR
betrifft ausschließlich die noch nicht implementierte
Infrastructure-Schicht.

## Offene Punkte (noch zu entscheiden)

- Endgültige Bestätigung Drift/SQLite vs. Isar durch den Auftraggeber.
- Konkretes Verschlüsselungsschema für lokale Daten (SQLCipher-Passphrase-
  Herkunft: Geräte-Keystore? Von ADR-02/ADR-06-Schlüsselmaterial
  abgeleitet?).
- Migrationsstrategie bei `schema_version`-Sprüngen (siehe Domain-Feld
  `schemaVersion` in `Tool`, `LoanRequest`, `Loan`, `DomainEvent` – bereits
  vorbereitet, aber ohne konkrete Migrationslogik).

## Konsequenz

Die Domain-Schicht ist unabhängig von dieser Entscheidung nutzbar; eine
spätere Wahl von Isar statt Drift/SQLite hätte keine Auswirkung auf
`lib/domain/`, nur auf die noch zu bauende Persistenz-Schicht darüber.
