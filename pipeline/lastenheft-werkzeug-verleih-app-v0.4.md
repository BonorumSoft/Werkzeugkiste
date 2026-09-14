# Lastenheft – Community-Werkzeug-Verleih-App

**Version:** 0.4
**Status:** Konsolidierte Anforderungsspezifikation
**Ziel:** Grundlage für Konzeption, UX/UI und spätere technische Umsetzung

## Änderungen gegenüber v0.3

- **Korrektur Abschnitt 48**: Satz zum Relay-Betreiber korrigiert (widersprach zuvor der E2E-Verschlüsselungsanforderung).
- **Abschnitt 4 / 7 / 10**: Klarstellung, dass ein Werkzeug genau einer Community zugeordnet ist; Doppel-Angebot desselben physischen Werkzeugs in mehreren Communities explizit als Nicht-MVP-Fall benannt.
- **Abschnitt 4 / 44**: Leihfristen/Fälligkeitsdaten/Rückgabe-Erinnerungen explizit als Nicht-MVP-Funktion aufgenommen (vorher unklar/nicht erwähnt).
- **Abschnitt 9 / ADR-02**: Bekannte MVP-Einschränkung ergänzt – entfernte Mitglieder können ohne Schlüsselrotation weiterhin gültige signierte Events einspeisen.
- **Abschnitt 20**: Rückweg aus dem `CONFLICT`-Zustand im Sync-Zustandsautomaten ergänzt.
- **Abschnitt 28 / 46**: Fehlende Geräte-Widerrufsstrategie (verlorenes/gestohlenes Gerät) als bekanntes Risiko dokumentiert.
- **Abschnitt 47**: ADR-08 „Relay-/Blob-Storage-Betrieb" ergänzt (Betriebs- und Kostenmodell bisher ungeklärt).

---

# 1. Zielsetzung und Produktvision

Die App ermöglicht es Mitgliedern einer **privaten, geschlossenen Community**, Werkzeuge und Geräte untereinander zu verleihen.

Die Anwendung soll dabei bewusst **nicht-kommerziell, kostenlos und privacy-first** konzipiert werden.

Ein Nutzer soll insbesondere:

- sehen können, welche Werkzeuge innerhalb seiner Communities vorhanden sind,
- eigene Werkzeuge anbieten können,
- Werkzeuge anderer Mitglieder anfragen können,
- Leihanfragen bestätigen oder ablehnen können,
- ausgeliehene Werkzeuge zurückgeben und die Rückgabe bestätigen können,
- jederzeit nachvollziehen können, **was er wann von wem geliehen bzw. an wen verliehen hat**.

Die Anwendung soll ohne zentrale Betreiberplattform funktionieren.

## 1.1 Leitprinzipien

Die folgenden Prinzipien sind verbindlich:

1. **Private Communities statt öffentlichem Marktplatz**
2. **Kein Geld innerhalb des MVP**
3. **Kein zentraler Betreiber-Server als Single Point of Failure**
4. **Local-first / Offline-first**
5. **Ende-zu-Ende-Verschlüsselung**
6. **Datensparsamkeit**
7. **Nutzer besitzt seine Identität und Daten**
8. **Keine zentrale Benutzerverwaltung**
9. **Keine zentrale Datenbank**
10. **Keine unnötige Bürokratie oder komplexe Bedienung**

---

# 2. Zielgruppe

Die Anwendung richtet sich zunächst an:

- Freundeskreise
- Nachbarschaften
- Familien
- Vereine
- private Interessengruppen
- Hausgemeinschaften
- kleine lokale Gemeinschaften

Die Community ist grundsätzlich **geschlossen**.

Eine öffentliche Suche nach Werkzeugen oder Nutzern gehört nicht zum MVP.

---

# 3. MVP – Funktionsumfang

Der MVP muss mindestens folgende Funktionen unterstützen:

### Community

- Community erstellen
- Community beitreten
- Mitglieder einladen
- mehrere Communities pro Nutzer
- Mitglieder einer Community anzeigen
- Community verlassen

### Werkzeuge

- Werkzeug anlegen
- eigenes Werkzeug bearbeiten
- eigenes Werkzeug löschen
- Werkzeuge anderer Mitglieder anzeigen
- Werkzeugkategorie
- Bezeichnung
- optional Hersteller/Modell
- optionale Beschreibung
- optionale Fotos
- optionaler Zustand
- Verfügbarkeitsstatus

### Ausleihe

- Leihanfrage stellen
- Leihanfrage ablehnen
- Leihanfrage bestätigen
- Werkzeug wird dadurch als verliehen markiert
- Rückgabe bestätigen
- Werkzeug wird wieder verfügbar

### Persönliche Leihhistorie

Jeder Nutzer kann lokal nachvollziehen:

**„Was habe ich wann von wem geliehen?"**

und

**„Was habe ich wann an wen verliehen?"**

Die Historie ist Bestandteil des MVP.

### Synchronisation

- Offline-Nutzung
- lokale Speicherung
- Synchronisation bei bestehender Verbindung
- Wiederholung fehlgeschlagener Synchronisation
- Konflikterkennung
- deterministische Konfliktbehandlung

### Sicherheit

- kryptografische Identität
- Ende-zu-Ende-Verschlüsselung
- sichere Speicherung privater Schlüssel
- verschlüsselte Fotos
- geschützte Backups

---

# 4. Explizit nicht Bestandteil des MVP

Folgende Funktionen werden bewusst ausgeschlossen:

- öffentliche Werkzeugangebote
- öffentliche Nutzerprofile
- Bewertungen
- Sterne/Ratings
- Vertrauensscores
- Bezahlung
- Mietpreise
- Kaution
- Vertragsverwaltung
- digitale Mietverträge
- Zahlungsabwicklung
- Kalenderbuchungen
- zentrale Administration
- zentrale Benutzerkonten
- serverseitige Push-Infrastruktur
- Social Recovery
- komplexe Multi-Device-Identitäten
- direkte Bluetooth-/Wi-Fi-P2P-Synchronisation
- **gleichzeitiges Anbieten desselben physischen Werkzeugs in mehreren Communities** (ein Werkzeug ist im MVP genau einer Community zugeordnet, siehe Abschnitt 7 und 10)
- **Leihfristen, Fälligkeitsdaten und Rückgabe-Erinnerungen** (kein `expected_return_at`, keine Benachrichtigung bei Überschreitung)

Diese Funktionen können später betrachtet werden.

---

# 5. Nutzer und Identität

## 5.1 Kryptografische Identität

Jeder Nutzer besitzt eine kryptografische Identität.

Als technisches Modell wird eine **Nostr-artige Public-/Private-Key-Identität** vorgesehen.

Der Public Key dient als technische Identität des Nutzers.

Der Private Key:

- darf das Gerät nicht ungeschützt verlassen,
- darf nicht in Logs auftauchen,
- darf nicht an einen Server übertragen werden,
- muss sicher auf dem Gerät gespeichert werden.

Geeignete Betriebssystemmechanismen wie:

- Apple Keychain / Secure Enclave
- Android Keystore
- biometrische Authentifizierung

sollen verwendet werden.

## 5.2 Benutzername

Die technische Identität des Nutzers ist nicht vom Anzeigenamen abhängig.

Ein Nutzer kann einen lokalen Anzeigenamen besitzen.

Die fachliche Zuordnung von:

- Werkzeugbesitzer
- Ausleiher
- Community-Mitglied

erfolgt über die kryptografische Identität.

---

# 6. Identitätssicherung und Backup

Der Nutzer muss seine Identität sichern können.

Vorgesehen sind:

1. geschütztes Plattform-Backup
2. manueller Export des Seeds bzw. Schlüsselmaterials

Mögliche Plattformmechanismen:

- iCloud Keychain
- Google Password Manager
- vergleichbare sichere Betriebssystemmechanismen

Die App soll dem Nutzer einen verständlichen Status anzeigen, beispielsweise:

> **Identität gesichert**

bzw.

> **Identität noch nicht gesichert**

Der Verlust des privaten Schlüssels darf nicht stillschweigend zu einem Verlust der Identität führen.

---

# 7. Communities

Eine Community ist ein abgeschlossener Datenraum.

Eine Community besitzt mindestens:

- Community ID
- kryptografischen Community-Schlüssel
- Liste der bekannten Mitglieder
- Community-Metadaten

Ein Nutzer darf gleichzeitig Mitglied mehrerer Communities sein.

Daten einer Community dürfen nicht automatisch für andere Communities sichtbar sein.

Ein Werkzeug (siehe Abschnitt 10) ist im MVP **genau einer Community zugeordnet**. Möchte ein Nutzer dasselbe physische Werkzeug in mehreren Communities anbieten, entstehen zwei unabhängige Tool-Datensätze ohne gegenseitige Verfügbarkeitsprüfung – ein Doppel-Verleih desselben physischen Gegenstands kann dadurch nicht durch die Domain-Logik verhindert werden. Das ist im MVP explizit in Kauf genommen (siehe Abschnitt 4) und sollte in der UI so kommuniziert werden, dass ein Nutzer ein Werkzeug bewusst nur in einer Community listet.

---

# 8. Einladungen

Eine Einladung soll logisch aus drei Komponenten bestehen:

- Community ID
- Community Key
- Invite Token

Der Invite Token soll:

- zufällig erzeugt werden,
- nicht erratbar sein,
- optional zeitlich begrenzt werden können,
- optional nur einmal verwendet werden können.

Die genaue kryptografische Umsetzung wird in einem separaten ADR festgelegt.

Eine gültige Einladung gewährt dem Empfänger Zugriff auf die entsprechende Community.

Ein dauerhaft öffentlich geteilter Community-Schlüssel soll nach Möglichkeit vermieden werden.

---

# 9. Mitgliederverwaltung

Innerhalb einer Community sollen Mitglieder angezeigt werden können.

Mindestens erforderlich:

- Anzeigename
- Public Key bzw. technische Identität
- Mitgliedsstatus

Ein Nutzer kann eine Community verlassen.

### Einschränkung im MVP

Beim Verlassen einer Community wird **keine vollständige kryptografische Rücknahme bereits verteilter Daten garantiert**.

Ein ehemaliges Mitglied kann daher möglicherweise weiterhin Daten besitzen, die bereits auf seinem Gerät synchronisiert wurden.

Darüber hinaus besitzt ein entferntes Mitglied ohne Schlüsselrotation weiterhin den alten Community-Schlüssel und kann damit technisch **weiterhin gültig signierte Events einspeisen** (z. B. eine gefälschte Leihanfrage), solange keine Schlüsselrotation stattgefunden hat. Dies ist eine bewusst dokumentierte MVP-Einschränkung (siehe ADR-02, Abschnitt 47) und kein Implementierungsfehler – sie muss den Nutzern in der UI transparent gemacht werden (z. B. Hinweis: „Entfernte Mitglieder haben ggf. weiterhin Zugriff, bis der Community-Schlüssel erneuert wurde").

Eine vollständige Schlüsselrotation mit Versionierung kann später eingeführt werden.

---

# 10. Werkzeuge

Jedes Werkzeug besitzt mindestens:

```text
Tool
├── tool_id
├── owner_pubkey
├── community_id
├── name
├── category
├── model?
├── description?
├── photos?
├── condition?
├── status
├── updated_at
└── schema_version
```

`community_id` ist ein einzelner Wert (kein Array) – ein Werkzeug gehört genau einer Community an (siehe Abschnitt 7).

## 10.1 Eigentum

Der Besitzer eines Werkzeugs wird über `owner_pubkey` bestimmt.

Ein Nutzer darf grundsätzlich nur seine eigenen Werkzeuge verändern oder löschen.

## 10.2 Werkzeugstatus

Ein Werkzeug besitzt einen eindeutigen Zustand.

```text
AVAILABLE
   ↓
REQUESTED
   ↓
LOANED
   ↓
AVAILABLE
```

Zusätzlich:

```text
DELETED
```

Eine Anfrage kann abgelehnt oder vom Anfragenden zurückgezogen werden:

```text
AVAILABLE
   ↓
REQUESTED
   ↓
AVAILABLE
```

Ungültige Zustandsübergänge müssen von der Domain-Logik verhindert werden.

---

# 11. Leihanfrage

Eine Leihanfrage besitzt mindestens:

```text
LoanRequest
├── request_id
├── tool_id
├── community_id
├── requester_pubkey
├── owner_pubkey
├── requested_at
├── status
└── schema_version
```

Mögliche Zustände:

```text
PENDING
ACCEPTED
REJECTED
CANCELLED
```

## 11.1 Regeln

Im MVP darf für ein Werkzeug maximal **eine aktive Leihanfrage** existieren (die Regel gilt pro Werkzeug, nicht pro Werkzeug+Anfragendem).

Der Besitzer erhält die Möglichkeit:

- Anfrage anzunehmen
- Anfrage abzulehnen

Der Anfragende kann eine offene Anfrage zurückziehen.

---

# 12. Leihvorgang

Der Leihvorgang beginnt **exakt mit der Bestätigung durch den Eigentümer**.

Es gibt keinen separaten Übergabezeitpunkt.

Das bedeutet:

> **Bestätigung = Beginn der Ausleihe**

Der Leihdatensatz lautet:

```text
Loan
├── loan_id
├── tool_id
├── community_id
├── owner_pubkey
├── borrower_pubkey
├── requested_at
├── accepted_at
├── returned_at
├── status
└── schema_version
```

### Bedeutung der Zeitstempel

| Feld | Bedeutung |
|---|---|
| `requested_at` | Zeitpunkt der Anfrage |
| `accepted_at` | Zeitpunkt der Eigentümer-Bestätigung und gleichzeitig Beginn der Ausleihe |
| `returned_at` | Zeitpunkt der vom Eigentümer bestätigten Rückgabe |

Es gibt **kein separates `lent_at`**.

Es gibt ebenfalls keinen manuellen „Übergabe bestätigen"-Schritt im MVP.

Ein Feld für eine erwartete Rückgabe (z. B. `expected_return_at`) ist im MVP bewusst **nicht** enthalten (siehe Abschnitt 4).

---

# 13. Leihzustandsmodell

Der fachliche Ablauf lautet:

```text
VERFÜGBAR
    │
    ▼
ANFRAGE GESTELLT
    │
    ├── Ablehnung ───────► VERFÜGBAR
    │
    └── Eigentümer bestätigt
                │
                ▼
             VERLIEHEN
                │
                │ Rückgabe
                ▼
       Eigentümer bestätigt Rückgabe
                │
                ▼
           VERFÜGBAR
```

Bei der Bestätigung:

```text
accepted_at = aktueller Zeitpunkt
```

Bei der Rückgabebestätigung:

```text
returned_at = aktueller Zeitpunkt
```

---

# 14. Rückgabe

Die Rückgabe wird vom Eigentümer bestätigt.

Dadurch:

1. endet der aktive Leihvorgang,
2. wird `returned_at` gesetzt,
3. erhält der Loan den Status `COMPLETED`,
4. wird das Werkzeug wieder `AVAILABLE`.

Eine erneute Ausleihe kann anschließend beantragt werden.

---

# 15. Persönliche Leihhistorie

Die persönliche Leihhistorie ist ein **MVP-Bestandteil**.

Sie ist keine öffentliche Statistik und kein Bewertungsprofil.

Jeder Nutzer soll zwei Perspektiven sehen können:

## 15.1 „Von anderen geliehen"

Beispiel:

> 🔨 Bosch Bohrhammer
> von Max geliehen
> 12.09.2026, 18:42 → 14.09.2026, 10:15

## 15.2 „An andere verliehen"

Beispiel:

> 🔧 Akkuschrauber
> an Max verliehen
> 10.09.2026, 17:30 → 11.09.2026, 09:10

Für einen aktuell laufenden Leihvorgang wird kein Rückgabezeitpunkt angezeigt.

Beispiel:

> 🔨 Bosch Bohrhammer
> von Max geliehen
> seit 12.09.2026, 18:42
> **Aktiv**

---

# 16. Anforderungen an die Leihhistorie

Die Historie muss mindestens enthalten:

- Werkzeug
- Community
- Gegenpartei
- Leihbeginn
- Rückgabezeitpunkt, sofern abgeschlossen
- aktueller bzw. historischer Status
- Richtung:
  - geliehen
  - verliehen

Die Historie soll lokal und offline verfügbar sein.

Sie soll mindestens filterbar sein nach:

- Community
- Werkzeug
- Zeitraum
- Richtung

---

# 17. „Wo wurde etwas geliehen?"

Im MVP bezeichnet „wo" zunächst die **Community**, in der der Leihvorgang stattgefunden hat.

Eine physische Ortsangabe oder GPS-Position ist **nicht Bestandteil des MVP**.

Beispiel:

> Bosch Bohrhammer
> von Max geliehen
> **Community: Nachbarschaft Brinkum**
> 12.09.2026, 18:42 → 14.09.2026, 10:15

Eine spätere Erweiterung um einen optionalen physischen Standort ist möglich, aber nicht Bestandteil dieses Lastenhefts.

---

# 18. Technische Historie vs. persönliche Historie

Diese beiden Konzepte müssen getrennt werden.

## 18.1 Technischer Event-Verlauf

Beispielsweise:

```text
ToolCreated
ToolUpdated
LoanRequested
LoanAccepted
LoanReturned
ToolDeleted
```

Dieser Verlauf dient insbesondere:

- Synchronisation
- Replikation
- Konfliktauflösung
- Wiederherstellung
- Konsistenzprüfung

## 18.2 Persönliche Leihhistorie

Die persönliche Historie ist eine **abgeleitete, nutzerorientierte Sicht** auf die relevanten Leihdaten.

Sie muss nicht zwingend als eigenständiger unveränderlicher Event-Datensatz gespeichert werden.

Sie kann aus den verschlüsselten Ereignissen rekonstruiert und lokal optimiert gespeichert werden.

---

# 19. Löschen lokaler Historie

Der Nutzer soll seine lokal gespeicherte persönliche Historie löschen können.

Das Löschen der eigenen lokalen Historie darf nicht die historischen Daten anderer Community-Mitglieder zerstören.

Insbesondere darf das Löschen einer lokalen Historie nicht automatisch bedeuten:

> „Alle zugehörigen Events aus dem verteilten Netzwerk löschen."

Die genaue Behandlung wird durch das Datenschutz-/Löschkonzept definiert.

---

# 20. Offline-first

Die App muss auch ohne Netzwerk sinnvoll funktionieren.

Folgende Aktionen müssen lokal möglich sein:

- Communities anzeigen
- Werkzeuge anzeigen
- eigene Werkzeuge bearbeiten
- Leihanfragen vorbereiten
- verfügbare lokale Daten anzeigen
- persönliche Historie anzeigen

Aktionen, die eine Synchronisation benötigen, werden lokal als ausstehend gespeichert.

Beispiel:

```text
LOCAL
  ↓
PENDING
  ↓
SYNCING
  ↓
SYNCED
```

Bei Fehler:

```text
FAILED
```

Bei Konflikten:

```text
CONFLICT
  │
  │ Konfliktauflösung nach deterministischen Regeln (siehe Abschnitt 22 / ADR-04)
  ▼
SYNCED
```

Netzwerkfehler dürfen niemals dazu führen, dass eine bereits lokal bestätigte Benutzeraktion verloren geht.

---

# 21. Synchronisation

Die Anwendung soll ohne zentralen Datenbankserver funktionieren.

Als primärer Mechanismus für die verteilte Synchronisation wird im MVP ein **Nostr-basiertes Modell** vorgesehen.

Es sollen mehrere Relays unterstützt werden.

Ein einzelner Relay darf kein Single Point of Failure sein.

Die lokale Datenbank dient unter anderem als:

- Offline-Datenspeicher
- lokaler Cache
- Event-Index
- Pending-Queue
- Statusspeicher

---

# 22. Konfliktauflösung

Da mehrere Geräte bzw. Nutzer unabhängig voneinander Aktionen durchführen können, müssen Konflikte berücksichtigt werden.

Beispielsweise:

- zwei Geräte bearbeiten dasselbe Werkzeug,
- mehrere Anfragen entstehen,
- ein Werkzeug wird offline als verfügbar angezeigt,
- während es auf einem anderen Gerät bereits verliehen wurde.

Die Domain-Schicht muss Konflikte anhand deterministischer Regeln behandeln.

Die Regeln werden in einem separaten ADR spezifiziert.

Wichtig:

> Konfliktauflösung darf nicht von UI oder Netzwerkcode abhängen.

---

# 23. Verschlüsselung

Private Community-Daten müssen Ende-zu-Ende-verschlüsselt werden.

Dazu gehören insbesondere:

- Werkzeugdaten
- Mitgliedsinformationen
- Leihanfragen
- Leihhistorie
- private Metadaten
- Fotos

Ein Relay-Betreiber darf daraus keine lesbaren privaten Informationen gewinnen können.

Es dürfen ausschließlich etablierte und geprüfte kryptografische Verfahren und Bibliotheken verwendet werden.

**Keine eigene Kryptografie.**

---

# 24. Fotos

Fotos von Werkzeugen müssen vor der Übertragung geschützt werden.

Vor dem Upload:

1. EXIF-Daten entfernen
2. insbesondere GPS-Daten entfernen
3. Bild ggf. verkleinern/komprimieren
4. Bild verschlüsseln
5. verschlüsseltes Bild übertragen

Es reicht ausdrücklich **nicht**, lediglich die URL oder Referenz auf ein unverschlüsseltes Bild zu verschlüsseln.

Die Bilddatei selbst muss verschlüsselt sein.

---

# 25. Dezentrale Speicherung von Bildern

Für Bilder soll ein Blossom-kompatibler Ansatz verwendet werden.

Die Anwendung darf nicht dauerhaft von einem einzelnen Storage-Anbieter abhängig sein.

Wo sinnvoll, sollen mehrere Speicheranbieter unterstützt bzw. Bilder repliziert werden.

Der eigentliche Inhalt bleibt verschlüsselt.

In den verschlüsselten Daten wird beispielsweise eine Referenz bzw. ein Content Hash gespeichert.

---

# 26. Datenschutz / DSGVO

Die Anwendung soll nach den Prinzipien:

- Privacy by Design
- Privacy by Default
- Datensparsamkeit

entwickelt werden.

Es sollen möglichst wenige personenbezogene Daten erhoben werden.

Insbesondere sollen keine unnötigen:

- E-Mail-Adressen
- Telefonnummern
- Standortdaten
- Gerätekennungen
- Trackingdaten

zentral gesammelt werden.

---

# 27. Grenzen des Löschens

Bei einem verteilten System kann nicht garantiert werden, dass ein einmal veröffentlichtes Event aus jedem Relay vollständig verschwindet.

Die App soll vorhandene Löschmechanismen nutzen.

Gleichzeitig muss dem Nutzer transparent erklärt werden:

> Das Löschen lokaler Daten ist zuverlässig möglich; das vollständige Löschen bereits replizierter Daten aus fremden/verteilten Speichern kann technisch nicht garantiert werden.

---

# 28. Multi-Device

Im MVP besitzt ein Nutzer grundsätzlich eine kryptografische Identität.

Diese Identität kann auf einem weiteren Gerät wiederhergestellt werden.

Der Transfer soll über einen geschützten Backup-/Recovery-Mechanismus erfolgen.

Eine komplexe Architektur mit separaten kryptografischen Geräteidentitäten ist zunächst nicht erforderlich.

**Bekannte MVP-Einschränkung:** Es existiert im MVP kein Mechanismus, um ein einzelnes verlorenes oder gestohlenes Gerät zu widerrufen, ohne die gesamte Identität (Private Key) zu wechseln. Ein entsperrtes, gestohlenes Gerät gewährt damit vollen Zugriff auf alle Communities des Nutzers, bis die Identität aktiv gewechselt wird. Dieses Risiko ist bewusst dokumentiert (siehe Abschnitt 46) und sollte den Nutzern in der App transparent gemacht werden (z. B. Hinweis bei Verlust: „Bei Geräteverlust sollte die Identität schnellstmöglich gewechselt werden").

---

# 29. Push-Benachrichtigungen

Serverbasierte Push-Benachrichtigungen sind **nicht Bestandteil des MVP**.

Die Synchronisation kann erfolgen bei:

- App-Start
- manuellem Refresh
- aktivem Synchronisationsvorgang
- geeigneten Hintergrundmechanismen des Betriebssystems

Eine spätere Benachrichtigungsbrücke kann geprüft werden.

---

# 30. Benutzeroberfläche

Die Benutzeroberfläche soll bewusst einfach gehalten werden.

Zentrale Bereiche:

### Communities

- Meine Communities
- Community auswählen
- Mitglieder
- Einladung

### Werkzeuge

- Alle Werkzeuge
- Meine Werkzeuge
- Verfügbare Werkzeuge
- verliehene Werkzeuge
- Werkzeugdetails

### Anfragen

- eingehende Anfragen
- eigene Anfragen
- Anfrage bestätigen
- Anfrage ablehnen
- Anfrage zurückziehen

### Ausleihen

- aktuell geliehene Werkzeuge
- aktuell verliehene Werkzeuge
- Rückgabe bestätigen

### Historie

- von anderen geliehen
- an andere verliehen
- Filter

---

# 31. Statusdarstellung

Der Status eines Werkzeugs muss eindeutig erkennbar sein.

Beispielsweise:

- Verfügbar
- Anfrage offen
- Verliehen
- Meine Anfrage
- Meine Ausleihe

Der Status darf **nicht ausschließlich über Farbe** vermittelt werden.

---

# 32. Barrierefreiheit

Die Anwendung muss mindestens unterstützen:

- Screenreader
- ausreichende Kontraste
- dynamische Schriftgrößen
- ausreichend große Touch-Ziele
- semantische Beschriftungen
- keine ausschließliche Farbcodierung

Barrierefreiheit soll bereits im MVP berücksichtigt werden.

---

# 33. Sicherheitsanforderungen

Mindestens erforderlich:

- sichere Zufallszahlengenerierung
- sichere Schlüsselablage
- biometrischer/PIN-basierter Zugriff
- keine Secrets in Logs
- keine Secrets im Repository
- verschlüsselte private Daten
- verschlüsselte Fotos
- Eingabevalidierung
- Berechtigungsprüfung in der Domain-Schicht
- Dependency Security Scanning
- Secret Scanning
- Schutz vor manipulierten Events

---

# 34. Lokale Missbrauchskontrolle

Da es keinen zentralen Betreiber gibt, kann kein klassisches zentrales Moderationssystem vorausgesetzt werden.

Die App soll dennoch lokale Schutzmechanismen unterstützen, beispielsweise:

- ungültige Events verwerfen
- unbekannte Signaturen verwerfen
- ungültige Zustandsübergänge ablehnen
- manipulierte Daten erkennen
- übermäßig große Datenmengen begrenzen

---

# 35. Technische Zielrichtung

Die Anwendung soll plattformübergreifend entwickelt werden.

Als technische Kandidaten werden derzeit betrachtet:

- Flutter / Dart
- Riverpod
- Drift / SQLite oder Isar
- Nostr-kompatible Dart-Bibliothek

Diese Entscheidungen sind grundsätzlich noch durch ADRs zu bestätigen.

Die Domain-Logik darf keine direkte Abhängigkeit zu:

- Flutter
- SQLite
- Nostr
- konkreten Storage-Anbietern

besitzen.

---

# 36. Architekturprinzip

Die Anwendung soll logisch in Schichten strukturiert werden:

```text
UI / Presentation
        │
        ▼
Application / State
        │
        ▼
Domain
        │
        ├── Community
        ├── Tool
        ├── Loan
        ├── State Machine
        └── Conflict Resolution
        │
        ▼
Data / Infrastructure
        ├── Local Database
        ├── Nostr
        ├── Blob Storage
        └── Cryptography
```

Die Domain muss unabhängig von konkreten technischen Implementierungen testbar sein.

---

# 37. Lokale Datenbank

Lokal sollen mindestens folgende Informationen verwaltet werden können:

- Communities
- Mitglieder
- Werkzeuge
- Leihanfragen
- Leihvorgänge
- persönliche Historie
- technische Events
- Pending Events
- Synchronisationsstatus
- Fotometadaten
- Schlüsselreferenzen

Die persönliche Historie soll als optimierte lokale Ansicht verfügbar sein.

---

# 38. Event-Modell

Das Event-Modell muss versioniert werden.

Mindestens folgende fachliche Ereignisse werden benötigt:

```text
ToolCreated
ToolUpdated
ToolDeleted

LoanRequested
LoanAccepted
LoanRejected
LoanCancelled
LoanReturned
```

Jedes Event benötigt eine eindeutige Identifikation und muss kryptografisch authentifiziert werden.

Die konkrete Nostr-/NIP-Ausgestaltung wird in einem ADR festgelegt.

---

# 39. Teststrategie

Besonders intensiv müssen getestet werden:

### Domain

- Werkzeug-State-Machine
- Leihprozess
- Berechtigungen
- Konfliktauflösung
- Eventvalidierung

### Security

- Schlüsselverwaltung
- Verschlüsselung
- Signaturprüfung
- Manipulation
- ungültige Events

### Offline

- Netzwerkverlust
- Wiederverbindung
- doppelte Events
- verzögerte Events
- Konflikte

### Historie

- korrekte Zuordnung geliehen/verliehen
- korrekter Leihbeginn
- korrekter Rückgabezeitpunkt
- aktive vs. abgeschlossene Leihen
- Löschen lokaler Historie

---

# 40. Testabdeckung

Eine Zielgröße von ungefähr **80 % für kritische Logik** wird angestrebt.

Entscheidend ist nicht eine möglichst hohe Gesamtquote, sondern eine hohe Abdeckung der kritischen Geschäftslogik.

Besonders wichtig:

> Ein Fehler in der Leih-State-Machine darf nicht durch UI-Tests unentdeckt bleiben.

---

# 41. CI/CD

Bei jedem Pull Request sollen mindestens ausgeführt werden:

- Formatting
- Linting
- Static Analysis
- Unit Tests
- Widget Tests
- Integration Tests, soweit relevant
- Security Scans
- Secret Scanning
- Dependency Checks

Ein Merge soll grundsätzlich nur bei erfolgreicher Pipeline möglich sein.

Produktionsfehler werden nach Möglichkeit als Regressionstest aufgenommen.

---

# 42. Beta-Test

Für die Beta sollen unter anderem getestet werden:

- zwei Smartphones
- mehrere Nutzer
- mehrere Communities
- instabile Netzwerkverbindung
- Offline-Betrieb
- Relay-Ausfall
- Storage-Ausfall
- konkurrierende Änderungen
- Foto-Upload
- Wiederherstellung einer Identität

---

# 43. Observability

Fehler- und Crash-Reporting darf keine privaten Inhalte offenlegen.

Insbesondere dürfen nicht übertragen werden:

- Private Keys
- Community Keys
- unverschlüsselte Tool-Daten
- Leihinformationen
- Fotos
- private Event-Payloads

Fehlerdiagnose soll möglichst über technische Metadaten erfolgen.

---

# 44. Zukünftige Erweiterungen

## 44.1 Öffentliche Werkzeuge

Eine spätere Erweiterung könnte öffentliche Werkzeugangebote ermöglichen.

Dann wären beispielsweise relevant:

- Sichtbarkeit
- Preis
- Währung
- grober Standort
- öffentliche Kategorien

Für Standortangaben soll zunächst höchstens ein grober Geohash, beispielsweise ca. 1 km, verwendet werden.

Keine exakten Wohnadressen.

## 44.2 Zahlungen

Eine spätere Erweiterung könnte beispielsweise Bitcoin Lightning / NIP-57 / Zaps betrachten.

Dies ist ausdrücklich **keine MVP-Anforderung**.

Vor einer tatsächlichen Zahlungsfunktion sind insbesondere rechtliche und steuerliche Fragen zu prüfen.

## 44.3 Leihfristen und Erinnerungen

Eine spätere Erweiterung könnte ein optionales Feld für eine erwartete Rückgabe (`expected_return_at`) sowie lokale Erinnerungen einführen. Dies ist bewusst nicht Teil des MVP (siehe Abschnitt 4).

## 44.4 Werkzeuge in mehreren Communities

Eine spätere Erweiterung könnte die Zuordnung eines Werkzeugs zu mehreren Communities mit gegenseitiger Verfügbarkeitsprüfung ermöglichen. Im MVP bleibt ein Werkzeug einer einzelnen Community zugeordnet (siehe Abschnitt 4, 7, 10).

## 44.5 Geräte-Widerruf

Eine spätere Erweiterung könnte einen Mechanismus zum selektiven Widerruf einzelner Geräte (ohne vollständigen Identitätswechsel) einführen, z. B. über geräte-spezifische Unterschlüssel.

---

# 45. App-Store- und Compliance-Anforderungen

Vor einer öffentlichen Veröffentlichung müssen unter anderem geprüft werden:

- App-Store-Richtlinien
- Datenschutzanforderungen
- Verschlüsselungs-/Exportanforderungen
- rechtliche Anforderungen für Deutschland/EU
- Anforderungen an Drittanbieterbibliotheken
- Lizenzbedingungen verwendeter Komponenten

---

# 46. Kritische Risiken

| Risiko | Bedeutung |
|---|---|
| Verlust des Private Keys | sehr hoch |
| Kompromittierter Community Key | sehr hoch |
| Relay-Ausfall | mittel |
| Blob-Storage-Ausfall | mittel |
| Konflikte bei Offline-Nutzung | hoch |
| Reife der Flutter/Nostr-Bibliotheken | mittel |
| DSGVO-Löschung in dezentralen Systemen | hoch |
| Komplexität der Kryptografie | sehr hoch |
| Wiederherstellung auf neuem Gerät | hoch |
| **Kein Widerruf einzelner Geräte bei Verlust/Diebstahl** | **hoch** |
| **Weiterhin gültige Events entfernter Mitglieder ohne Schlüsselrotation** | **mittel bis hoch** |

Die Risiken sollen bereits in der Architektur- und Testphase adressiert werden.

---

# 47. Offene technische Entscheidungen / ADRs

Folgende Themen müssen vor der Implementierung konkret entschieden und dokumentiert werden:

### ADR-01 – Nostr Event-Modell
- verwendete Event-Typen
- NIPs
- Tags
- Signaturen
- Verschlüsselungsverfahren

### ADR-02 – Community-Verschlüsselung
- Schlüsselverteilung
- Schlüsselrotation
- Umgang mit ausgeschiedenen Mitgliedern
- **Schutz vor bzw. Umgang mit weiterhin gültigen Events entfernter Mitglieder ohne Schlüsselrotation** (siehe Abschnitt 9)

### ADR-03 – Invite-System
- Tokenformat
- Ablauf
- Einmalverwendung
- sichere Übertragung des Community-Schlüssels

### ADR-04 – Konfliktauflösung
- Prioritätsregeln
- Event-Reihenfolge
- konkurrierende Leihanfragen
- konkurrierende Werkzeugänderungen

### ADR-05 – Foto-Storage
- Blossom-Anbieter
- Redundanz
- Upload-/Download-Protokoll
- Content Hash

### ADR-06 – Backup / Recovery
- Plattformbackup
- Seed Export
- Wiederherstellung
- Schutz gegen Schlüsselverlust
- Widerruf einzelner Geräte (siehe Abschnitt 28, 44.5)

### ADR-07 – Lokale Datenbank
- Drift/SQLite vs. Isar
- Verschlüsselung lokaler Daten
- Migrationen

### ADR-08 – Relay- und Blob-Storage-Betrieb
- Nutzung öffentlicher Nostr-Relays vs. eigene Relay-Instanz
- Betreiber und Finanzierung des Blossom-/Blob-Storage
- Kostenmodell für „kostenlos für alle Nutzer"
- Skalierung bei wachsender Nutzerzahl

---

# 48. Akzeptanzkriterien MVP

Der MVP gilt fachlich als erfolgreich umgesetzt, wenn folgender Ablauf funktioniert:

### Szenario

**Person A** und **Person B** besitzen jeweils ein Smartphone.

1. Person A erstellt eine private Community.
2. Person A lädt Person B ein.
3. Person B tritt der Community bei.
4. Person A legt einen Bohrhammer an.
5. Person B sieht den Bohrhammer.
6. Person B stellt eine Leihanfrage.
7. Person A sieht die Anfrage.
8. Person A bestätigt die Anfrage.
9. `accepted_at` wird gesetzt.
10. Der Bohrhammer steht auf **VERLIEHEN**.
11. Person B sieht den Bohrhammer als aktuell geliehen.
12. Person A sieht ihn als aktuell verliehen.
13. Beide Geräte verlieren anschließend die Netzwerkverbindung.
14. Die lokale Historie bleibt verfügbar.
15. Person A bestätigt später die Rückgabe.
16. `returned_at` wird gesetzt.
17. Der Loan wird `COMPLETED`.
18. Der Bohrhammer wird wieder `AVAILABLE`.
19. Beide Nutzer sehen den abgeschlossenen Leihvorgang in ihrer persönlichen Historie.

Dabei darf:

- kein zentraler Benutzeraccount erforderlich sein,
- keine zentrale Datenbank erforderlich sein,
- ein einzelner Relay-Ausfall die Anwendung nicht dauerhaft unbrauchbar machen,
- der Relay-Betreiber private Community-Inhalte **nicht** lesen können.

---

# 49. Erfolgskriterium

Der MVP ist erfolgreich, wenn zwei oder mehr Personen auf unterschiedlichen Smartphones innerhalb einer privaten Community Werkzeuge **sicher, dezentral und auch zeitweise offline** miteinander verleihen können.

Dabei müssen insbesondere folgende Eigenschaften erfüllt sein:

> **Einfach:**
> Werkzeug auswählen → Anfrage stellen → Besitzer bestätigt → geliehen.

> **Nachvollziehbar:**
> Jeder Nutzer kann seine persönliche Leihhistorie einsehen.

> **Privat:**
> Außenstehende können die privaten Inhalte nicht lesen.

> **Dezentral:**
> Kein einzelner Betreiber kontrolliert die Community-Daten.

> **Robust:**
> Temporäre Netzwerk- oder Relay-Ausfälle dürfen keine lokalen Daten zerstören.

> **Klar:**
> Die Eigentümer-Bestätigung ist gleichzeitig der Beginn der Ausleihe. Eine zusätzliche Übergabebestätigung ist nicht erforderlich.

---

## 50. Zusammenfassung des MVP

Das Produkt lässt sich damit auf einen sehr klaren Kern reduzieren:

**Community → Werkzeuge → Anfrage → Bestätigung → Ausleihe → Rückgabe → Historie**

mit den vier zentralen Eigenschaften:

**privat · kostenlos · dezentral · offline-first**

Die persönliche Historie ist dabei kein späteres Komfortfeature, sondern ein **integraler Bestandteil des MVP**.
