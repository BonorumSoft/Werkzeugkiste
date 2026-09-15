/// Generischer Hilfsbaustein für die enum-basierten Zustandsautomaten der
/// Domain-Schicht.
///
/// PHASE 5 (Refactor): Vor diesem Baustein pflegten `tool.dart` (Tool-Status)
/// und `loan_request.dart` (LoanRequest-Status) unabhängig voneinander
/// dasselbe Muster – Übergangs-Map plus ein `isValidXTransition`/
/// `assertValidXTransition`-Funktionspaar. Dieser Baustein bündelt die
/// gemeinsame Prüf-/Wurf-Logik an einer Stelle. Die öffentlichen Funktionen
/// `isValidToolTransition`/`assertValidToolTransition` in `tool.dart` sowie
/// `isValidLoanRequestTransition`/`assertValidLoanRequestTransition` in
/// `loan_request.dart` bleiben unverändert bestehen (gleiche Signatur,
/// gleiches Verhalten) und delegieren nur noch hierher – kein Testverhalten
/// ändert sich dadurch (siehe reports/phase5_refactor.md).
library;

import "exceptions.dart";

/// Prüft anhand der Übergangs-Map [allowedTransitions], ob der Übergang
/// [from] -> [to] zulässig ist.
bool isValidTransition<S>(Map<S, Set<S>> allowedTransitions, S from, S to) {
  return allowedTransitions[from]?.contains(to) ?? false;
}

/// Wirft [InvalidStateTransition], falls [from] -> [to] laut
/// [allowedTransitions] nicht zulässig ist.
void assertValidTransition<S extends Object>(
  Map<S, Set<S>> allowedTransitions,
  S from,
  S to,
) {
  if (!isValidTransition(allowedTransitions, from, to)) {
    throw InvalidStateTransition(from, to);
  }
}
