# ADR-08 – Relay- und Blob-Storage-Betrieb

**Status:** Entschieden (Tjorben, September 2026, auf Basis des Claude-
Vorschlags). Betrifft ausschließlich Infrastrukturkonfiguration.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Nutzung
öffentlicher Nostr-Relays vs. eigene Relay-Instanz, Betreiber und
Finanzierung des Blossom-/Blob-Storage, Kostenmodell für „kostenlos für
alle Nutzer" (Abschnitt 1), Skalierung bei wachsender Nutzerzahl.

## Wichtige Vereinfachung durch ADR-05

Mit der Entscheidung in ADR-05 (Fotos komplett lokal, Verteilung über
denselben Kanal wie Domain-Events statt über einen separaten
Blob-Storage-Anbieter) entfällt der **Blob-Storage-Teil dieser ADR
vollständig** – es gibt keinen Blossom-Server und damit auch keine
Blossom-Betriebs-/Kostenfrage mehr. Übrig bleibt die reine
Relay-Betriebsfrage.

## Vorschlag

**Für den MVP: ausschließlich öffentliche, etablierte Nostr-Relays,
keine eigene Relay-Instanz.** Begründung: Die App soll laut Abschnitt 1
dauerhaft kostenlos bleiben; ein selbst betriebener Relay-Server
erzeugt laufende Infrastrukturkosten (Hosting, Wartung, Verfügbarkeit)
ohne fachlichen Mehrwert für den MVP, solange die App-Daten ohnehin
Ende-zu-Ende-verschlüsselt sind (Abschnitt 23) – der Relay-Betreiber
kann die Inhalte ohnehin nicht lesen, wodurch das übliche
Vertrauensargument für einen eigenen Relay ("wem vertraue ich mit
meinen Klartextdaten") hier entfällt.

**Redundanz:** Jede Community konfiguriert mehrere (Vorschlag: 2–3)
unabhängige öffentliche Relays gleichzeitig, damit der Ausfall eines
einzelnen Relay-Betreibers den Sync nicht komplett unterbricht – Standard-
Pattern in Nostr-Clients. Konkrete Namen bewusst nicht in dieser ADR
festgeschrieben, da sich das Angebot öffentlicher Relays über die Zeit
ändert; Auswahl sollte zum Implementierungszeitpunkt anhand von
Uptime-Historie und Event-Größenlimit (siehe ADR-01/ADR-05) getroffen
werden.

**Skalierung/Kostenmodell:** Da (a) kein Blob-Storage mehr anfällt
(ADR-05) und (b) reguläre Text-/JSON-Events klein sind, bleibt die
Bandbreitenlast pro Community gering. Größere Fotos (ADR-05) sind der
einzige relevante Bandbreitenfaktor – die dort vorgeschlagene
Kompression/Größenbegrenzung wirkt damit auch hier direkt kostendämpfend.
**Optionaler Ausblick, kein MVP-Bestandteil:** Falls eine Community
langfristig höhere Zuverlässigkeit will, kann sie freiwillig einen
eigenen Relay betreiben (z. B. finanziert über eine Spende innerhalb
der Community) – das ist eine lokale Entscheidung einzelner
Communities, keine App-weite Infrastrukturverpflichtung.

## Offene Punkte (auch nach diesem Vorschlag)

- Konkrete Relay-Auswahl/-Liste ist eine Implementierungs-, keine
  Architekturentscheidung und sollte erst kurz vor MVP-Launch final
  getroffen werden (Verfügbarkeit ändert sich).

## Konsequenz für den Code

Kein Domain-Layer-Code betroffen – reine Infrastrukturkonfiguration.
