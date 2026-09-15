# ADR-05 – Foto-Storage

**Status:** Offen – keine Arbeitsannahme getroffen, keine Implementierung
vorhanden.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Blossom-Anbieter,
Redundanz, Upload-/Download-Protokoll, Content Hash.

## Stand

`lib/domain/tool.dart` hält bereits ein Feld `photoRefs` (`List<String>`)
vor – bewusst als Liste opaker Referenzen (z. B. Content-Hashes oder
URLs), NICHT als eingebettete Bilddaten, damit die Domain-Schicht von der
konkreten Blossom-Anbindung unabhängig bleibt (Abschnitt 23, 36). Die
tatsächliche Upload-/Download-Logik, Redundanzstrategie und
Hash-Verifikation sind nicht implementiert (Infrastructure-Schicht,
außerhalb des in Phase 3/4 gewählten Scopes).

## Offene Punkte (vollständig, da noch nichts entschieden)

- Welche(r) Blossom-Server/-Anbieter genutzt wird (öffentlich vs.
  selbst betrieben – hängt inhaltlich mit ADR-08 zusammen).
- Redundanzstrategie (Upload zu mehreren Blossom-Servern gleichzeitig?).
- Konkretes Upload-/Download-Protokoll und Fehlerbehandlung bei
  nicht erreichbarem Server.
- Content-Hash-Algorithmus (Blossom verwendet üblicherweise SHA-256 über
  den Dateiinhalt als Adressierung – müsste als Format für `photoRefs`
  festgelegt werden, aktuell ist das Feld bewusst nur `String` ohne
  Formatvorgabe).

## Konsequenz

`Tool.photoRefs` ist bereits so geschnitten, dass eine spätere
ADR-05-Entscheidung keine Breaking Change am Domain-Modell erfordert,
solange das Ergebnis weiterhin als Liste von String-Referenzen
darstellbar ist.
