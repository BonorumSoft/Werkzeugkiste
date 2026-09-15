# ADR-01 – Nostr Event-Modell

**Status:** Vorgeschlagen (Arbeitsannahme aus Phase 3/4), NICHT final durch
den Auftraggeber bestätigt.

## Kontext

Lastenheft Abschnitt 47 verlangt vor der Implementierung eine Entscheidung
über: verwendete Event-Typen, NIPs, Tags, Signaturen,
Verschlüsselungsverfahren. Die Domain-Schicht (`lib/domain/events.dart`)
musste bereits in Phase 3/4 ein Strukturmodell für fachliche Events
besitzen, um die Zustandsautomaten (Tool, LoanRequest, Loan) an etwas
Serialisierbares anzubinden, ohne dabei selbst Kryptografie zu
implementieren (Abschnitt 23: „keine eigene Kryptografie" – das ist
Aufgabe der Infrastructure-Schicht).

## Bisherige Arbeitsannahme (siehe `pipeline/00_offene_fragen.md`, Punkt 3)

Jedes fachliche Event (`ToolCreated`, `ToolUpdated`, `ToolDeleted`,
`LoanRequested`, `LoanAccepted`, `LoanRejected`, `LoanCancelled`,
`LoanReturned` – siehe `lib/domain/events.dart`) wird als NIP-44-
verschlüsselter, signierter Nostr-Event mit einem Custom-Kind-Range
(z. B. 30000er „addressable events", damit ein Event pro Entität durch
`d`-Tag ersetzbar/aktualisierbar ist statt sich unbegrenzt zu häufen)
abgebildet. Jede `DomainEvent`-Subklasse trägt bereits die dafür nötigen
Pflichtfelder `eventId`, `signerPubkey`, `signature`, `occurredAt`.

## Offene Punkte (noch zu entscheiden)

- Konkrete Kind-Nummern je Event-Typ (Vorschlag: 30078–30085 als
  Custom-Range, siehe NIP-33/NIP-78-Konventionen für addressable events –
  müsste gegen tatsächlich verwendete Nostr-Client-/Relay-Kompatibilität
  geprüft werden).
- Exaktes Tag-Schema (z. B. `["d", "<tool_id>"]` für Tool-Events,
  `["e", "<referenziertes_event>"]` für Verkettung von LoanRequest→Loan).
- Ob NIP-44 (verschlüsselte DMs/Gruppen) tatsächlich das richtige
  Verschlüsselungs-NIP für Community-weite (nicht 1:1-)Kommunikation ist,
  oder ob ein gruppenfähiges Schema (z. B. geteilter Community-Schlüssel,
  siehe ADR-02) direkt auf Event-Content-Ebene angewendet wird.
- Wie `schema_version` (Domain-Feld, siehe `lib/domain/tool.dart` etc.) im
  Event-Envelope transportiert wird (Tag vs. Content-Feld).

## Konsequenz

Die Domain-Schicht ist absichtlich so geschnitten, dass sie von dieser
Entscheidung unabhängig bleibt: `DomainEvent` kennt nur, DASS es eine
Signatur geben muss, nicht WIE sie erzeugt/geprüft wird. Eine spätere
ADR-01-Entscheidung erfordert daher keine Änderung an `lib/domain/`,
sondern nur an der noch nicht implementierten Infrastructure-Schicht
(Nostr-Client-Bindung).
