# ADR-02 – Community-Verschlüsselung

**Status:** Teilweise offen. Ein Teilaspekt (Umgang mit entfernten
Mitgliedern) ist als bekannte MVP-Einschränkung dokumentiert; Schlüssel-
verteilung/-rotation sind NICHT entschieden.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über:
Schlüsselverteilung, Schlüsselrotation, Umgang mit ausgeschiedenen
Mitgliedern, und explizit den Schutz vor weiterhin gültigen Events
entfernter Mitglieder ohne Schlüsselrotation (Änderung gegenüber v0.3,
siehe Abschnitt 9 und Risikotabelle Abschnitt 46: Risiko „mittel bis
hoch").

## Bisheriger Stand in der Domain-Schicht

`lib/domain/community.dart` hält `communityKeyRef` bewusst nur als
**opaken String-Verweis** auf das tatsächliche Schlüsselmaterial – die
Domain-Schicht selbst erzeugt, verteilt oder rotiert keine Schlüssel
(Abschnitt 23). `Community.withMemberRemoved()` setzt den
Mitgliedsstatus lokal auf `removed`, macht aber **keine** Aussage über
kryptografische Konsequenzen (Code-Kommentar in `community.dart`
verweist bereits explizit auf diese Lücke).

## Bekannte, im MVP akzeptierte Einschränkung (Abschnitt 9)

Ohne Schlüsselrotation bei Mitglieder-Austritt kann ein entferntes
Mitglied technisch weiterhin gültig signierte Events einspeisen, die von
anderen Clients (die den alten Community-Schlüssel noch nicht als
ungültig kennen) akzeptiert würden. Das Lastenheft nimmt dieses Risiko für
den MVP bewusst in Kauf (Änderungshistorie v0.3→v0.4, Abschnitt 46:
Risiko „mittel bis hoch", aber kein MVP-Blocker).

## Offene Punkte (noch zu entscheiden)

- Verteilungsmechanismus für den Community-Schlüssel an neue Mitglieder
  (hängt direkt an ADR-03, Invite-System).
- Ob und wann eine spätere Version Schlüsselrotation nachrüstet (out of
  scope für MVP, aber Architekturauswirkung: `communityKeyRef` müsste
  dann versioniert werden – das Feld ist als einfacher String angelegt,
  keine Rotation vorgesehen).
- Konkretes Schlüsselformat/-algorithmus (z. B. symmetrischer Schlüssel
  pro Community, asymmetrisch pro Mitglied verpackt, o. ä.) – reine
  Infrastructure-Entscheidung, keine Domain-Auswirkung.

## Konsequenz

Kein Handlungsbedarf in `lib/domain/` bis zu einer konkreten ADR-02-
Entscheidung. Sollte eine spätere Entscheidung Schlüsselrotation
einführen, betrifft das ausschließlich die Infrastructure-Schicht und
ggf. eine Erweiterung von `Community` um ein Rotations-/Versionsfeld.
