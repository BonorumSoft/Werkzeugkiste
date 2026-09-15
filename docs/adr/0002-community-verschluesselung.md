# ADR-02 – Community-Verschlüsselung

**Status:** Entschieden (Tjorben, September 2026, auf Basis des Claude-
Vorschlags). Betrifft die noch nicht implementierte Infrastructure-/
Application-Schicht – die dafür bereits vorhandene Domain-Grundlage
(`Community.hasActiveMember()`, `communityKeyRef`) benötigt keine
Änderung.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über:
Schlüsselverteilung, Schlüsselrotation, Umgang mit ausgeschiedenen
Mitgliedern, und explizit den Schutz vor weiterhin gültigen Events
entfernter Mitglieder ohne Schlüsselrotation (Abschnitt 9, Risiko
„mittel bis hoch" laut Abschnitt 46).

## Vorschlag

**Schlüsselmaterial:** Ein symmetrischer 256-Bit-Schlüssel pro Community
("Community-Schlüssel"), zufällig erzeugt bei Community-Gründung.
Verschlüsselt damit den `content` aller Nostr-Events dieser Community
(siehe ADR-01). Entspricht dem bereits vorhandenen
`Community.communityKeyRef` in `lib/domain/community.dart` – die Domain-
Schicht hält nur den opaken Verweis, nicht den Schlüssel selbst
(Abschnitt 23: keine eigene Kryptografie in der Domain-Schicht).

**Verteilung an neue Mitglieder:** Über eine echte, individuelle
NIP-44-Verschlüsselung (Version 2, ECDH-basiert – hier in seiner
eigentlich vorgesehenen paarweisen Rolle, siehe ADR-01) vom
bestätigenden Mitglied an den neuen Pubkey. Details zum Ablauf (wer
bestätigt, wie der neue Pubkey bekannt wird) siehe ADR-03.

**Rotation bei Mitglieder-Entfernung:** Ein verbleibendes aktives
Mitglied erzeugt einen neuen Community-Schlüssel und verteilt ihn erneut
paarweise (NIP-44) an alle weiterhin aktiven Mitglieder. Das entfernte
Mitglied bekommt den neuen Schlüssel nicht und kann damit **keine neuen
Events mehr entschlüsseln** – wohl aber weiterhin die alten (kein
rückwirkender Schutz, technisch in einem System ohne zentrale
Löschautorität auch nicht erreichbar; dieselbe Einschränkung gilt für
praktisch jedes Ende-zu-Ende-verschlüsselte Gruppensystem, z. B. Signal-
Gruppen vor einem expliziten "History-off"-Beitritt).

**Zweite, unabhängige Verteidigungslinie gegen weiterhin gültige Events
entfernter Mitglieder:** Die Schlüsselrotation verhindert nur das LESEN
neuer Inhalte durch das entfernte Mitglied. Damit ein entferntes
Mitglied nicht weiterhin gültige SCHREIBOPERATIONEN einspeisen kann
(Kernrisiko aus Abschnitt 9/46), muss die Application-Schicht jedes
eingehende Event zusätzlich gegen `Community.hasActiveMember(signerPubkey)`
prüfen (Methode existiert bereits in `lib/domain/community.dart`) und
Events von nicht mehr aktiven Mitgliedern verwerfen – unabhängig davon,
ob das Event technisch korrekt entschlüsselt werden konnte. Erst diese
Kombination (Schlüsselrotation + Mitgliedschaftsprüfung) schließt die
Lücke praktisch vollständig; keine der beiden Maßnahmen allein reicht.

## Geprüfte, verworfene Alternative

Eigene asymmetrische Verschlüsselung pro Mitglied (jedes Event einzeln
für jeden aktiven Pubkey verschlüsseln) wurde verworfen: Aufwand skaliert
mit der Mitgliederzahl pro Event statt einmalig bei Schlüsselwechsel,
und NIP-44 ist für 1:n nicht vorgesehen (siehe ADR-01).

## Offene Punkte (auch nach diesem Vorschlag)

- Wer genau darf ein Mitglied entfernen und damit eine Rotation
  auslösen (nur der Community-Ersteller? Mehrheitsbeschluss? Das
  Lastenheft definiert bislang keine Rollen/Rechte-Hierarchie innerhalb
  einer Community über "Eigentümer eines Werkzeugs" hinaus – das wäre
  eine zusätzliche, hier nicht getroffene Annahme).
- Genaues Schlüsselableitungs-/Speicherformat auf dem Gerät (siehe
  ADR-07, lokale Verschlüsselung).

## Konsequenz für den Code

Keine Änderung an `lib/domain/community.dart` nötig –
`communityKeyRef` (opaker String) und `hasActiveMember()` sind bereits
so geschnitten, dass sie diesen Vorschlag tragen. Die eigentliche
Rotations-/Verteilungslogik gehört vollständig in die noch nicht
implementierte Infrastructure-/Application-Schicht.
