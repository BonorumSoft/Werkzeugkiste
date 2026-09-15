# ADR-03 – Invite-System

**Status:** Vorschlag (Claude, September 2026) – wartet auf Bestätigung
durch den Auftraggeber.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Tokenformat,
Ablauf, Einmalverwendung, sichere Übertragung des Community-Schlüssels
an neue Mitglieder.

## Vorschlag

**Grundproblem:** Bevor der neue Nutzer der Community beitritt, kennt
niemand seinen Pubkey – man kann ihm also noch nichts über Nostr
paarweise verschlüsselt zusenden (Henne-Ei-Problem). Der Invite-Schritt
muss daher zunächst AUSSERHALB von Nostr laufen.

**Tokenformat:** Ein zufälliger 128-Bit-Wert (16 Byte), base64url-kodiert,
eingebettet in einen teilbaren Link/QR-Code:

```
werkzeugkiste://invite?c=<community_id>&t=<token>&relay=<relay_hint>&exp=<unix_timestamp>
```

Übertragung dieses Links erfolgt bewusst außerhalb der App (Messenger,
AirDrop, QR-Code, persönlich) – das ist Stand der Technik für
Invite-Links in dezentralen/E2E-verschlüsselten Systemen (z. B. Signal-
Gruppenlinks funktionieren nach demselben Prinzip).

**Ablauf einer Einladung:**
1. Bestehendes Mitglied erzeugt den Link (Token + Ablaufzeitpunkt, Vorschlag: 7 Tage).
2. Neuer Nutzer öffnet den Link, die App generiert (falls noch nicht vorhanden) ein frisches Schlüsselpaar für dieses Gerät (siehe ADR-06 zur Empfehlung „ein Schlüsselpaar pro Gerät").
3. Die App des neuen Nutzers veröffentlicht ein signiertes `JoinRequest`-Event (referenziert Token-Hash, NICHT den Klartext-Token, um ihn nicht auf dem Relay offenzulegen).
4. Ein aktives Mitglied verifiziert Token und Ablaufzeit, sendet den aktuellen Community-Schlüssel per echter NIP-44-Verschlüsselung an den neuen Pubkey (siehe ADR-02).

**Einmalverwendung:** Das verifizierende Mitglied sendet zusätzlich ein
signiertes `InviteConsumed`-Event (referenziert den Token-Hash), damit
auch die Clients der übrigen Mitglieder den Token als verbraucht
markieren. Das ist **eventual consistency**, kein hartes Lock – bei
gleichzeitiger Nutzung durch zwei Personen könnten theoretisch kurzzeitig
beide durchkommen, bevor sich die `InviteConsumed`-Information verbreitet
hat. Diese Einschränkung ist strukturell dieselbe wie die bereits in
ADR-02/Abschnitt 9 akzeptierte MVP-Lücke bei entfernten Mitgliedern und
wird hier aus Konsistenzgründen genauso behandelt: dokumentiert, nicht
blockierend für den MVP.

## Offene Punkte (auch nach diesem Vorschlag)

- Wer darf Invite-Links erzeugen (jedes Mitglied oder nur bestimmte
  Rollen – hängt an derselben noch fehlenden Rollen-/Rechte-Frage wie
  in ADR-02 notiert).
- Verhalten bei abgelaufenem Token (Fehlermeldung vs. automatische
  Anfrage an den Ersteller für einen neuen Link).

## Konsequenz für den Code

Dieses Konzept führt eine neue Entität "Invite"/"JoinRequest" ein, die
im bisherigen Domain-Scope (Phase 3/4) nicht existiert. Keine
rückwirkende Änderung an bestehendem Code nötig; bei Umsetzung wäre ein
neues `lib/domain/invite.dart` (State Machine: PENDING → CONSUMED/
EXPIRED, analog zum bereits etablierten Muster in `loan_request.dart`)
der naheliegende Ort, testgetrieben nach demselben Phase-3/4-Prozess.
