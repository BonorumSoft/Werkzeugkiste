/// Domain-spezifische Fehler. Alle Domain-Operationen werfen ausschließlich
/// Subtypen von [DomainException] – niemals rohe [StateError]/[ArgumentError],
/// damit Application-/UI-Schicht gezielt reagieren können (Lastenheft
/// Abschnitt 33 „Berechtigungsprüfung in der Domain-Schicht",
/// Abschnitt 10.2 „Ungültige Zustandsübergänge müssen von der Domain-Logik
/// verhindert werden").
library;

sealed class DomainException implements Exception {
  const DomainException(this.message);

  final String message;

  @override
  String toString() => "$runtimeType: $message";
}

/// REQ: Ungültige Zustandsübergänge müssen von der Domain-Logik verhindert
/// werden (Abschnitt 10.2).
final class InvalidStateTransition extends DomainException {
  const InvalidStateTransition(this.from, this.to, [String? reason])
      : super(
          "Ungültiger Zustandsübergang: $from -> $to"
          "${reason != null ? ' ($reason)' : ''}",
        );

  final Object from;
  final Object to;
}

/// REQ: Ein Nutzer darf grundsätzlich nur eigene Werkzeuge verändern oder
/// löschen (Abschnitt 10.1). Gilt analog für Annahme/Ablehnung von Anfragen
/// (nur Eigentümer) und Rücknahme von Anfragen (nur Anfragender) sowie
/// Rückgabebestätigung (nur Eigentümer, Abschnitt 14).
final class PermissionDenied extends DomainException {
  const PermissionDenied(String action, {required this.actor, required this.requiredRole})
      : super("Aktion '$action' verweigert für $actor (erforderlich: $requiredRole)");

  final String actor;
  final String requiredRole;
}

/// REQ: Für ein Werkzeug darf maximal eine aktive Leihanfrage existieren
/// (Abschnitt 11.1) – Regel gilt pro Werkzeug, nicht pro Werkzeug+Anfragendem.
final class DuplicateActiveLoanRequest extends DomainException {
  const DuplicateActiveLoanRequest(String toolId)
      : super("Für Werkzeug '$toolId' existiert bereits eine aktive Leihanfrage");
}

/// Strukturelle Validierungsfehler an Entitäten/Events (z. B. leere
/// Pflichtfelder), unabhängig von Zustandsübergängen.
final class InvalidDomainData extends DomainException {
  const InvalidDomainData(super.message);
}
