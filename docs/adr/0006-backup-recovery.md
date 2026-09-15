# ADR-06 – Backup / Recovery

**Status:** Vorschlag (Claude, September 2026) – wartet auf Bestätigung
durch den Auftraggeber. Das Lastenheft (Abschnitt 46) stuft „kein
Widerruf einzelner Geräte bei Verlust/Diebstahl" als **hohes Risiko**
ein – diese ADR sollte entsprechend priorisiert entschieden werden.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über:
Plattformbackup, Seed Export, Wiederherstellung, Schutz gegen
Schlüsselverlust, Widerruf einzelner Geräte (Abschnitt 28, 44.5).

## Vorschlag

**Wichtige Grundempfehlung zuerst: ein eigenes Schlüsselpaar PRO GERÄT,
nicht ein Schlüsselpaar für alle Geräte eines Nutzers.** Das ist die
Voraussetzung dafür, dass Geräte-Widerruf überhaupt einfach lösbar wird
(siehe unten) – wird dieselbe Identität geräteübergreifend synchronisiert,
kompromittiert ein gestohlenes Gerät die Identität auf allen Geräten
gleichzeitig, und ein Widerruf ist nicht mehr isolierbar.

**Seed Export:** Klassischer BIP-39-artiger 24-Wörter-Mnemonic, der den
privaten Nostr-Schlüssel (nsec) dieses Geräts kodiert – etabliertes,
Nutzern aus anderen Wallet-/Signer-Apps bereits vertrautes Format.
Manuell exportierbar, z. B. beim Onboarding als „einmal aufschreiben"-
Schritt.

**Plattformbackup:** Optionales, explizites Opt-in (NICHT automatisch/
still, da hochsensibles Material) für Backup des verschlüsselten
Schlüssel-Blobs über iOS Keychain (mit iCloud-Schlüsselbund-Sync, falls
vom Nutzer systemseitig aktiviert) bzw. Android Keystore-gestütztes
Backup. Ohne Opt-in: reiner Seed-Export als einzige Sicherung.

**Wiederherstellung:** Neues Gerät, Seed-Phrase eingeben → nsec
wird abgeleitet → App fragt (sofern kein Plattformbackup vorhanden war)
über den in ADR-03 beschriebenen Mechanismus bei einem noch aktiven
Mitglied jeder bekannten Community erneut nach dem aktuellen
Community-Schlüssel (funktional wie ein erneuter Beitritt mit
bestehender Identität statt fremder).

**Geräte-Widerruf (Verlust/Diebstahl) – wiederverwendet bestehende
Mechanismen statt neuer Infrastruktur:** Da es keine zentrale PKI/
Geräteverwaltung gibt (dezentrale Architektur, Abschnitt 7), wird
Widerruf über genau denselben Weg gelöst wie eine normale
Mitglieder-Entfernung (ADR-02): Der Nutzer meldet (von einem anderen
Gerät oder über ein Mitglied seines Vertrauens) den Pubkey des
verlorenen/gestohlenen Geräts als kompromittiert. Alle Communities, in
denen dieser Pubkey Mitglied war, behandeln ihn wie ein entferntes
Mitglied (Schlüsselrotation + `hasActiveMember`-Prüfung, siehe ADR-02).
Der Nutzer erzeugt für sein Ersatzgerät ein frisches Schlüsselpaar und
tritt den Communities über den normalen Invite-Flow (ADR-03) erneut
bei. Kein neues Widerrufs-Protokoll nötig – reine Wiederverwendung der
Mitgliedschaftslogik, passend zu einer Architektur ohne zentrale
Autorität.

## Offene Punkte (auch nach diesem Vorschlag)

- UX-Frage (nicht rein technisch): Wie erfährt ein Nutzer, dass ein
  Gerät als "verloren" gemeldet werden sollte, wenn er selbst keinen
  Zugriff mehr darauf hat, aber auch kein Zweitgerät besitzt? Für den
  MVP wäre eine Mindestanforderung "mindestens ein weiteres vertrauens-
  würdiges Gerät oder ein Mitglied, das man informieren kann" plausibel
  – müsste im Onboarding kommuniziert werden.
- Ob/wie eine bereits erfolgte Kompromittierung VOR Meldung erkennbar
  gemacht werden kann (out of scope für reine Backup/Recovery-ADR).

## Konsequenz für den Code

Kein Domain-Layer-Code betroffen – reine Identitäts-/Schlüssel-
verwaltung (Infrastructure-Schicht) plus Wiederverwendung der bereits
vorhandenen `Community.hasActiveMember()`-Prüfung aus ADR-02.
