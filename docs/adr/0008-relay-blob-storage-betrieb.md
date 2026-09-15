# ADR-08 – Relay- und Blob-Storage-Betrieb

**Status:** Offen – keine Arbeitsannahme getroffen, keine Implementierung
vorhanden. In v0.4 gegenüber v0.3 neu ergänzt (siehe Änderungshistorie des
Lastenhefts).

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Nutzung
öffentlicher Nostr-Relays vs. eigene Relay-Instanz, Betreiber und
Finanzierung des Blossom-/Blob-Storage, Kostenmodell für „kostenlos für
alle Nutzer" (Abschnitt 1: Kernanforderung „privat, kostenlos"), Skalierung
bei wachsender Nutzerzahl.

## Stand

Nicht Teil des in Phase 3/4 gewählten Domain-Scopes – reine
Betriebs-/Infrastrukturentscheidung ohne Rückwirkung auf `lib/domain/`.
Diese ADR ist insofern besonders, als sie nicht nur eine technische,
sondern auch eine wirtschaftliche Entscheidung ist: Das Lastenheft fordert
in Abschnitt 1 ausdrücklich „kostenlos für alle Nutzer", was bei
öffentlichen Nostr-Relays (meist kostenlos, aber ohne Verfügbarkeits-
garantie) und Blossom-Storage (Speicherkosten skalieren mit Nutzerzahl und
Fotogröße) in Spannung zueinander stehen kann.

## Offene Punkte (vollständig, da noch nichts entschieden)

- Öffentliche Relays nutzen (kostenlos, aber keine Verfügbarkeits-/
  Datenschutzgarantie) vs. eigene Relay-Instanz betreiben (Kosten,
  Wartungsaufwand, dafür Kontrolle).
- Wer trägt die Betriebskosten für Blob-Storage bei wachsender
  Nutzerzahl, wenn das Produkt laut Anforderung dauerhaft kostenlos
  bleiben soll?
- Skalierungsstrategie (z. B. Foto-Kompression/-Limits pro Werkzeug, um
  Speicherkosten zu begrenzen – aktuell setzt `Tool.photoRefs`
  (`lib/domain/tool.dart`) keine Obergrenze).

## Konsequenz

Diese Entscheidung hat keine Domain-Auswirkung, ist aber eine
Voraussetzung für ein tragfähiges Betriebsmodell und sollte vor einer
produktiven Einführung mit realen Nutzern (nicht nur MVP-Test) geklärt
sein.
