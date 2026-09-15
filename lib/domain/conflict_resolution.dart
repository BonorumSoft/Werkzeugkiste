/// Deterministische Konfliktauflösung (Lastenheft Abschnitt 22).
///
/// ANNAHME (siehe pipeline/00_offene_fragen.md, Punkt 2 – ADR-04 steht noch
/// aus): Last-Writer-Wins nach `updatedAt`; bei identischem `updatedAt`
/// entscheidet ein lexikographischer Vergleich einer stabilen Tie-Break-ID.
/// Diese Regel ist eine Arbeitsannahme für Testzwecke, KEINE endgültige
/// ADR-04-Entscheidung.
///
/// Wichtig (Abschnitt 22): Diese Funktion hängt ausschließlich von den
/// übergebenen Werten ab – keine UI-, Netzwerk- oder Zeit-Seiteneffekte.
library;

/// Interface für Entitäten, die konfliktfähig sind (per Domain-Layer,
/// framework-frei).
abstract interface class Versioned {
  DateTime get updatedAt;

  /// Stabile, deterministisch vergleichbare ID für den Tie-Break-Fall.
  String get conflictTieBreakId;
}

/// Löst einen Konflikt zwischen zwei unabhängig entstandenen Versionen
/// derselben Entität deterministisch auf.
///
/// Regel: die Version mit dem späteren `updatedAt` gewinnt. Bei exakt
/// gleichem `updatedAt` gewinnt die Version mit der lexikographisch
/// GRÖSSEREN `conflictTieBreakId` (willkürlich, aber deterministisch und
/// auf allen Geräten identisch reproduzierbar).
T resolveConflict<T extends Versioned>(T a, T b) {
  if (a.updatedAt.isAfter(b.updatedAt)) return a;
  if (b.updatedAt.isAfter(a.updatedAt)) return b;
  return a.conflictTieBreakId.compareTo(b.conflictTieBreakId) >= 0 ? a : b;
}
