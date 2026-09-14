// Traceability: REQ Abschnitt 22 (deterministische Konfliktauflösung),
// REQ Abschnitt 20 (CONFLICT-Zustand -> SYNCED nach deterministischen
// Regeln). Testet die in pipeline/00_offene_fragen.md dokumentierte
// Arbeitsannahme (Last-Writer-Wins + Tiebreak), NICHT die noch offene
// ADR-04-Endentscheidung.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/conflict_resolution.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "fixtures.dart";

void main() {
  group("resolveConflict (Last-Writer-Wins, Arbeitsannahme ADR-04 ausstehend)", () {
    test("die Version mit späterem updatedAt gewinnt", () {
      final older = buildAvailableTool(updatedAt: t0);
      final newer = buildAvailableTool(updatedAt: t0.add(const Duration(minutes: 1)))
          .copyWith(name: "Geändert auf Gerät 2");

      final winner = resolveConflict(older, newer);
      expect(winner.name, "Geändert auf Gerät 2");
    });

    test("Reihenfolge der Argumente ändert das Ergebnis nicht (Determinismus)", () {
      final older = buildAvailableTool(updatedAt: t0);
      final newer = buildAvailableTool(updatedAt: t0.add(const Duration(minutes: 1)));

      expect(resolveConflict(older, newer).updatedAt, newer.updatedAt);
      expect(resolveConflict(newer, older).updatedAt, newer.updatedAt);
    });

    test("bei identischem updatedAt entscheidet der Tiebreak deterministisch und reproduzierbar", () {
      final a = buildAvailableTool(toolId: "tool-aaa", updatedAt: t0);
      final b = buildAvailableTool(toolId: "tool-bbb", updatedAt: t0);

      final result1 = resolveConflict(a, b);
      final result2 = resolveConflict(a, b);
      final result3 = resolveConflict(b, a);

      // Determinismus: wiederholte Aufrufe mit denselben Eingaben liefern
      // dasselbe Ergebnis, unabhängig von der Aufrufreihenfolge.
      expect(result1.toolId, result2.toolId);
      expect(result1.toolId, result3.toolId);
      // Mit der dokumentierten Regel (lexikographisch größere ID gewinnt)
      // gewinnt hier "tool-bbb" > "tool-aaa".
      expect(result1.toolId, "tool-bbb");
    });
  });
}
