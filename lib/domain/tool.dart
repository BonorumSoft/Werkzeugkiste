import "package:meta/meta.dart";

import "conflict_resolution.dart";
import "ids.dart";
import "state_machine.dart" as state_machine;

/// Zustand eines Werkzeugs (Lastenheft Abschnitt 10.2).
///
/// Bewusst NUR diese fünf Werte – kein `expired`/`overdue` o. ä., da
/// Leihfristen/Fälligkeitsdaten kein MVP-Bestandteil sind (Abschnitt 4, 12).
enum ToolStatus { available, requested, loaned, deleted }

/// Erlaubte Zustandsübergänge der Tool-State-Machine (Abschnitt 10.2).
///
/// AVAILABLE -> REQUESTED   (Leihanfrage gestellt)
/// REQUESTED -> LOANED      (Eigentümer bestätigt)
/// REQUESTED -> AVAILABLE   (Ablehnung oder Rücknahme der Anfrage)
/// LOANED    -> AVAILABLE   (Rückgabe bestätigt)
/// AVAILABLE -> DELETED     (Eigentümer löscht ein verfügbares Werkzeug)
///
/// Alle anderen Übergänge (z. B. AVAILABLE -> LOANED direkt, DELETED -> *,
/// REQUESTED -> DELETED, LOANED -> REQUESTED) sind ungültig.
///
/// ANNAHME (siehe pipeline/00_offene_fragen.md): Das Lastenheft spezifiziert
/// nicht explizit, ob ein Werkzeug aus REQUESTED oder LOANED gelöscht werden
/// darf. Diese Implementierung lässt DELETED nur aus AVAILABLE zu, um keine
/// Anfrage/Ausleihe verwaist zurückzulassen. Diese Annahme ist dokumentiert
/// und muss ggf. per Rückmeldung des Auftraggebers bestätigt werden.
const Map<ToolStatus, Set<ToolStatus>> _allowedToolTransitions = {
  ToolStatus.available: {ToolStatus.requested, ToolStatus.deleted},
  ToolStatus.requested: {ToolStatus.loaned, ToolStatus.available},
  ToolStatus.loaned: {ToolStatus.available},
  ToolStatus.deleted: {},
};

/// Prüft, ob der Übergang [from] -> [to] laut Tool-State-Machine gültig ist.
bool isValidToolTransition(ToolStatus from, ToolStatus to) =>
    state_machine.isValidTransition(_allowedToolTransitions, from, to);

/// Wirft `InvalidStateTransition`, falls der Übergang ungültig ist.
void assertValidToolTransition(ToolStatus from, ToolStatus to) =>
    state_machine.assertValidTransition(_allowedToolTransitions, from, to);

/// Werkzeug-Datensatz (Lastenheft Abschnitt 10).
///
/// `communityId` ist bewusst ein Einzelwert (kein `List<String>`) – ein
/// Werkzeug gehört im MVP genau einer Community an (Abschnitt 7, 10).
///
/// GUARD (Abschnitt 4, 12, 44.3): Dieses Modell besitzt bewusst KEIN Feld
/// `expected_return_at` und keine Leihfrist/Fälligkeitslogik.
@immutable
final class Tool implements Versioned {
  const Tool({
    required this.toolId,
    required this.ownerPubkey,
    required this.communityId,
    required this.name,
    required this.category,
    required this.status,
    required this.updatedAt,
    this.model,
    this.description,
    this.photoRefs = const [],
    this.condition,
    this.schemaVersion = 1,
  })  : assert(toolId.length > 0, "toolId darf nicht leer sein"),
        assert(name.length > 0, "name darf nicht leer sein"),
        assert(category.length > 0, "category darf nicht leer sein");

  final ToolId toolId;
  final Pubkey ownerPubkey;

  /// Einzelwert – siehe Klassendokumentation und Abschnitt 7/10.
  final CommunityId communityId;

  final String name;
  final String category;
  final String? model;
  final String? description;
  final List<String> photoRefs;
  final String? condition;
  final ToolStatus status;
  final DateTime updatedAt;
  final int schemaVersion;

  bool isOwnedBy(Pubkey pubkey) => ownerPubkey == pubkey;

  /// Für [resolveConflict]: Tiebreak über die stabile toolId.
  @override
  String get conflictTieBreakId => toolId;

  Tool copyWith({
    ToolStatus? status,
    String? name,
    String? category,
    String? model,
    String? description,
    List<String>? photoRefs,
    String? condition,
    DateTime? updatedAt,
  }) {
    return Tool(
      toolId: toolId,
      ownerPubkey: ownerPubkey,
      communityId: communityId,
      name: name ?? this.name,
      category: category ?? this.category,
      model: model ?? this.model,
      description: description ?? this.description,
      photoRefs: photoRefs ?? this.photoRefs,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      schemaVersion: schemaVersion,
    );
  }

  /// Für Guard-Tests / Serialisierung: enthält ausschließlich die im
  /// Lastenheft (Abschnitt 10) genannten Felder. Ein Test kann so prüfen,
  /// dass z. B. `expected_return_at` NICHT als Key vorkommt.
  Map<String, Object?> toJson() => {
        "tool_id": toolId,
        "owner_pubkey": ownerPubkey,
        "community_id": communityId,
        "name": name,
        "category": category,
        "model": model,
        "description": description,
        "photos": photoRefs,
        "condition": condition,
        "status": status.name,
        "updated_at": updatedAt.toIso8601String(),
        "schema_version": schemaVersion,
      };
}
