# ADR-01 – Nostr Event-Modell

**Status:** Entschieden (Tjorben, September 2026, auf Basis des Claude-
Vorschlags). Ersetzt die vorherige, unspezifische Arbeitsannahme aus
Phase 3/4. Betrifft die noch nicht implementierte Infrastructure-Schicht
(siehe „Konsequenz für den Code" unten) – keine Domain-Code-Änderung
durch diese Entscheidung.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: verwendete
Event-Typen, NIPs, Tags, Signaturen, Verschlüsselungsverfahren. Die
Domain-Schicht (`lib/domain/events.dart`) kennt bereits 8 fachliche
Event-Typen (`ToolCreated`, `ToolUpdated`, `ToolDeleted`,
`LoanRequested`, `LoanAccepted`, `LoanRejected`, `LoanCancelled`,
`LoanReturned`) mit den Pflichtfeldern `eventId`, `signerPubkey`,
`signature`, `occurredAt`, `schemaVersion`.

## Vorschlag

**Event-Kind-Kategorie: „regular events" (NIP-01), NICHT addressable/
replaceable.** Unsere `DomainEvent`s sind ein unveränderliches Log
("was ist passiert", nicht "wie ist der aktuelle Zustand") – das
entspricht exakt der NIP-01-Definition von regulären Events: „expected
to be stored by relays" ohne Ersetzungssemantik. Der `d`-Tag-Mechanismus
der addressable events (Kind 30000–39999) würde bedeuten, dass ältere
Versionen von Relays verworfen werden dürfen – das widerspricht dem
Event-Log-Charakter und würde die History (Abschnitt 15/39, "Wer hat
wann was geändert") zerstören.

**Vorgeschlagener Kind-Bereich: 8200–8207** (ein Kind je der 8
`DomainEvent`-Subklassen), im unbelegten 8000er-Bereich (Stand
September 2026 laut Kind-Registry-Check; im Bereich 9000–9043 liegen
bereits NIP-29-Gruppen- und Zap-Kinds, siehe unten). **Vor tatsächlicher
Implementierung erneut gegen die dann aktuelle NIP-Kind-Registry
prüfen** – Kind-Zuweisungen sind kein statisches Dokument.

**Tags:**
- `["e", "<tool_id | request_id | loan_id>"]` – Korrelations-Tag, damit
  ein Relay-Filter (`#e`) alle Events zu genau einer Entität liefert.
  Bewusste Zweckentfremdung des `e`-Tags (eigentlich für Event-IDs
  gedacht) – pragmatisch üblich, weil es das einzige von Relays
  standardmäßig indexierte Tag ist, das für diesen Zweck passt.
- `["p", "<betroffener_pubkey>"]` – z. B. der Anfragende bei
  `LoanRequested`, damit dessen Client auch ohne Kenntnis der
  `tool_id` im Voraus relevante Events findet.
- `schemaVersion` wandert NICHT in einen Tag, sondern bleibt Teil des
  JSON-Envelope im `content`-Feld (konsistent mit den bereits
  bestehenden `toJson()`-Methoden der Domain-Entitäten).

**Verschlüsselung:** NIP-44 (aktuell Version 2: secp256k1-ECDH + HKDF +
ChaCha20 + HMAC-SHA256) ist laut Spezifikation explizit für **paarweise**
Verschlüsselung zwischen zwei Schlüsselpaaren ausgelegt, NICHT für
Gruppen. Für Community-weite Events kann NIP-44 daher nicht direkt
verwendet werden. Vorschlag: `content` wird mit dem in ADR-02
vorgeschlagenen **symmetrischen Community-Schlüssel** verschlüsselt,
unter Wiederverwendung derselben Bausteine wie NIP-44 (ChaCha20 +
HMAC-SHA256 via HKDF), nur mit einem gemeinsamen statt einem per-ECDH
abgeleiteten Schlüssel. Das ist eine bewusste, dokumentierte Abweichung
von der NIP-44-Spezifikation (die selbst nur den Paar-Fall definiert),
keine falsche Anwendung.

## Geprüfte, verworfene Alternative

**NIP-29 (Relay-based Groups)** wurde geprüft, da es "Gruppen" bereits
im Protokoll modelliert. Verworfen, weil NIP-29 **nicht Ende-zu-Ende-
verschlüsselt** ist – die Mitgliedschafts- und Moderationslogik liegt
vollständig beim Relay-Betreiber ("relay MUST reject...", Relay als
zentrale Vertrauensinstanz). Das widerspricht Abschnitt 23 des
Lastenhefts (E2E-Verschlüsselung) und dem Grundprinzip "dezentral, kein
zentraler Server". NIP-29 wäre nur dann passend, wenn ein
Community-Betreiber dem Relay explizit vertrauen soll – nicht der Fall
hier.

## Offene Punkte (auch nach diesem Vorschlag)

- Endgültige Kind-Nummern müssen vor Implementierung final gegen die
  Registry geprüft werden.
- Wie mehrteilige/große Inhalte (siehe ADR-05, Fotoverteilung) innerhalb
  der relay-üblichen Event-Größenlimits abgebildet werden (Chunking?).

## Konsequenz für den Code

Keine Änderung an `lib/domain/events.dart` nötig – das Strukturmodell
(Pflichtfelder, `eventType`-Unterscheidung) ist mit diesem Vorschlag
vollständig kompatibel. Der Vorschlag betrifft ausschließlich die noch
nicht implementierte Infrastructure-Schicht.
