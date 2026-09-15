/// Kleine, abhängigkeitsfreie Ersetzung für `package:collection`s
/// `firstWhereOrNull` (bewusst keine zusätzliche Abhängigkeit für eine
/// einzelne Hilfsfunktion).
extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
