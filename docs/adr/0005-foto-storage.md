# ADR-05 – Foto-Storage

**Status:** Entschieden (Tjorben, September 2026).

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Blossom-
Anbieter, Redundanz, Upload-/Download-Protokoll, Content Hash.

## Entscheidung

**Komplett lokal, keine externe Blob-Storage (kein Blossom, kein
Cloud-Anbieter).** Fotos liegen ausschließlich auf den Geräten der
Community-Mitglieder. Wird ein Foto (neu hochgeladen oder geändert),
**wird es aktiv an alle Mitglieder verteilt** – jedes Gerät hält danach
eine vollständige lokale Kopie. Kein zentraler Speicherort, keine
Abhängigkeit von einem dritten Anbieter, keine damit verbundenen
laufenden Kosten (relevant für Abschnitt 1: „kostenlos für alle
Nutzer" – siehe auch ADR-08, das durch diese Entscheidung deutlich
einfacher wird).

## Wie die Verteilung technisch funktioniert (Ableitung aus der Entscheidung)

Da die App keinen anderen Sync-Kanal hat als die in ADR-01 beschriebene
Nostr-Relay-Anbindung, läuft die Fotoverteilung über denselben Kanal wie
die übrigen Domain-Events – nicht über einen separaten Blob-Server:

- Referenzierung: `Tool.photoRefs` (`List<String>`, bereits vorhanden in
  `lib/domain/tool.dart`) enthält weiterhin nur opake String-Referenzen –
  unter dieser Entscheidung konkret: **SHA-256-Content-Hashes** der
  Fotodatei. Damit kann jedes Gerät (a) prüfen, ob es ein referenziertes
  Foto bereits lokal hat, (b) die Integrität eines empfangenen Fotos
  gegen den Hash verifizieren, (c) Fotos dedupliziert vorhalten.
- Verteilung: Das eigentliche Bild wird – analog zu den fachlichen
  Events aus ADR-01 – community-verschlüsselt (ADR-02) über die Relays
  an alle Mitglieder übertragen (kein Domain-Layer-Unterschied zu
  anderen Events; auf Infrastruktur-Ebene ggf. als eigener, größerer
  Event- oder Chunk-Typ).
- **Wichtige technische Einschränkung, die vor Implementierung zu lösen
  ist:** Nostr-Relays begrenzen die Event-Größe häufig auf einen
  niedrigen zweistelligen bis niedrigen dreistelligen KB-Bereich (relay-
  abhängig, nicht protokollweit festgelegt). Fotos müssen daher vor
  Verteilung komprimiert/verkleinert werden (Vorschlag: harte Obergrenze
  z. B. 1–2 MB pro Foto nach Kompression, ggf. Aufteilung in mehrere
  Events/Chunks bei größeren Dateien) – siehe auch die offenen Punkte in
  ADR-01.

## Konsequenz für den Code

Keine Breaking Change an `lib/domain/tool.dart`: `photoRefs` bleibt
`List<String>`. Diese Entscheidung präzisiert nur die SEMANTIK der
bereits vorhandenen Strings (Content-Hash statt z. B. einer Blossom-URL)
– rein dokumentarisch, kein Code-Änderungsbedarf in der Domain-Schicht.
Die eigentliche Verteil-/Kompressions-/Chunking-Logik gehört vollständig
in die noch nicht implementierte Infrastructure-Schicht.
