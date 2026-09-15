# ADR-06 – Backup / Recovery

**Status:** Offen – keine Arbeitsannahme getroffen, keine Implementierung
vorhanden.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Plattformbackup,
Seed Export, Wiederherstellung, Schutz gegen Schlüsselverlust, Widerruf
einzelner Geräte (siehe Abschnitt 28, 44.5). Abschnitt 46 (Risikotabelle)
führt „kein Widerruf einzelner Geräte bei Verlust/Diebstahl" explizit als
**hohes** Risiko.

## Stand

Nicht Teil des in Phase 3/4 gewählten Domain-Scopes. Betrifft
ausschließlich Schlüsselverwaltung/Gerätekonten, die laut Abschnitt 23 in
der Infrastructure-Schicht (nicht der Domain-Schicht) verortet sind.

## Offene Punkte (vollständig, da noch nichts entschieden)

- Plattformbackup-Mechanismus (iCloud Keychain / Android Backup Service –
  jeweils mit eigenen Sicherheits- und Datenschutz-Implikationen).
- Seed-Export-Format und -Ablauf für manuelle Sicherung.
- Wiederherstellungsablauf auf einem neuen Gerät.
- **Geräte-Widerruf** (Abschnitt 28, 46): Wie ein verlorenes/gestohlenes
  Gerät nachträglich von weiterem Zugriff auf die Community
  ausgeschlossen wird – das Lastenheft benennt dies als offenes,
  hochpriorisiertes Risiko ohne bisherige Lösung.

## Konsequenz

Dies ist die am wenigsten spezifizierte der acht ADRs und sollte
angesichts der als „hoch" eingestuften Risikobewertung (Abschnitt 46)
priorisiert entschieden werden, sobald die Infrastructure-Schicht
angegangen wird – vor der Domain-Schicht besteht hierzu kein
unmittelbarer Handlungsbedarf.
