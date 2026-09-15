# ADR-04 – Konfliktauflösung

**Status:** Arbeitsannahme implementiert und getestet (Phase 3/4/6), NICHT
final durch den Auftraggeber bestätigt.

## Kontext

Lastenheft Abschnitt 47 verlangt eine Entscheidung über: Prioritätsregeln,
Event-Reihenfolge, konkurrierende Leihanfragen, konkurrierende
Werkzeugänderungen. Abschnitt 22 und 47 verweisen mehrfach auf
„deterministische Konfliktregeln", ohne sie zu spezifizieren.

## Bisherige Arbeitsannahme (implementiert in `lib/domain/conflict_resolution.dart`)

**Last-Writer-Wins nach `updatedAt`.** Bei exakt identischem `updatedAt`
entscheidet ein lexikographischer Vergleich einer stabilen
`conflictTieBreakId` (aktuell: `toolId` bei `Tool`, siehe
`Tool.conflictTieBreakId`). Diese Regel ist bewusst einfach und
deterministisch (jeder Client kommt bei denselben Eingabedaten zum
selben Ergebnis, ohne Koordination), aber NICHT identisch mit der in
`pipeline/00_offene_fragen.md` Punkt 2 ursprünglich skizzierten,
komplexeren Variante („Status mit höherer Priorität in der State-Machine
gewinnt zusätzlich zu Last-Writer-Wins") – letztere wurde nach Abwägung
NICHT umgesetzt, weil sie in der aktuellen Domain-Modellierung ohne
konkreten Konfliktfall-Katalog (welcher Status schlägt welchen bei
gleichem Zeitstempel?) nicht eindeutig spezifizierbar war und eine
falsche Annahme hier schwerer zu korrigieren gewesen wäre als eine zu
einfache. Diese Vereinfachung ist hiermit explizit dokumentiert.

**Konkurrierende Leihanfragen** werden NICHT über `resolveConflict()`
gelöst, sondern bereits präventiv durch die Domain-Regel „maximal eine
aktive Anfrage pro Werkzeug" verhindert (`DuplicateActiveLoanRequest`,
siehe `lib/domain/tool_service.dart::requestLoan()`, REQ-249, getestet in
`test/domain/loan_request_test.dart` und mutationsgetestet in Phase 6,
MUT-06). Ein echter Konflikt zwischen zwei Leihanfragen kann in diesem
Modell also gar nicht erst entstehen, solange alle Clients dieselbe
Domain-Logik anwenden – ein Konflikt entsteht nur, wenn zwei Geräte
OFFLINE gleichzeitig eine Anfrage stellen, bevor sie voneinander wissen.
Dieser Fall (Offline-Divergenz) ist durch `resolveConflict()` auf
Tool-Ebene abgedeckt: das später aktualisierte Tool (REQUESTED-Status)
gewinnt.

## Offene Punkte (noch zu entscheiden)

- Ob die einfache Last-Writer-Wins-Regel für **konkurrierende
  Werkzeugänderungen** (z. B. gleichzeitige Namensänderung durch den
  Eigentümer auf zwei Geräten) im Praxisbetrieb ausreicht, oder ob ein
  feldweises Merge (statt „ganzes Objekt gewinnt") gewünscht ist.
- Endgültige Event-Reihenfolge-Semantik auf Nostr-Ebene (hängt an ADR-01).

## Konsequenz

Diese Datei formalisiert die bisher nur in Code-Kommentaren und
`pipeline/00_offene_fragen.md` verstreute Annahme. Eine künftige
ADR-04-Entscheidung des Auftraggebers, die von Last-Writer-Wins abweicht,
erfordert eine Änderung ausschließlich in
`lib/domain/conflict_resolution.dart` (klar isolierte, einzige Stelle) und
den zugehörigen Tests in `test/domain/conflict_resolution_test.dart` –
kein anderer Teil der Domain-Schicht hängt an der konkreten Regel, nur an
der Existenz der Funktion `resolveConflict<T extends Versioned>`.
