# ADR-03 – Invite-System

**Status:** Offen – keine Arbeitsannahme getroffen, keine Implementierung
vorhanden.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Tokenformat,
Ablauf(-datum), Einmalverwendung, sichere Übertragung des
Community-Schlüssels an neue Mitglieder.

## Stand

Weder `lib/domain/` noch die Testsuite enthalten bislang ein
Invite-Modell. Der bisherige Implementierungs-Scope (Phase 3/4) hat sich
bewusst auf Tool-/Loan-/LoanRequest-Zustandsautomaten, Berechtigungen und
Konfliktauflösung konzentriert (siehe `reports/phase8_abschlussbericht.md`
für die vollständige Scope-Begründung) – das Invite-System war darin
nicht enthalten und wurde daher auch nicht testgetrieben entwickelt.

## Offene Punkte (vollständig, da noch nichts entschieden)

- Tokenformat (z. B. zufälliger String vs. signierter, zeitlich
  begrenzter Nostr-Event).
- Ablaufverhalten (Gültigkeitsdauer, ob Tokens nach Ablauf clientseitig
  oder relay-seitig ungültig werden).
- Einmalverwendung: technische Durchsetzung ist in einem dezentralen,
  serverlosen System (Abschnitt 7 f.) nicht trivial – ohne zentrale
  Instanz muss entweder auf Relay-seitige Konventionen oder auf
  „Erstnutzung gewinnt, spätere werden von Community-Mitgliedern als
  ungültig erkannt" ausgewichen werden.
- Sichere Übertragung des Community-Schlüssels an den neuen Nutzer
  (hängt direkt an ADR-02).

## Konsequenz

Diese Entscheidung ist eine Voraussetzung für jede künftige
Implementierung eines Invite-Ablaufs (Application-/Infrastructure-Schicht)
und für die Entity `Community`/`Member` in `lib/domain/community.dart`,
falls sich daraus zusätzliche Felder ergeben (z. B. ein
`invitedBy`-Verweis). Kein Rückwirkungsbedarf auf bereits implementierten
Code.
