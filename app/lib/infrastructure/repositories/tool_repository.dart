/// Persistenz-Adapter zwischen `ToolsTable` (Drift) und der Domain-Entität
/// `Tool` (`package:werkzeugkiste/domain/tool.dart`).
library;

import "dart:convert";

import "package:drift/drift.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "../database/app_database.dart";

class ToolRepository {
  ToolRepository(this._db);

  final AppDatabase _db;

  Stream<List<Tool>> watchToolsForCommunity(String communityId) {
    final query = _db.select(_db.toolsTable)
      ..where((t) => t.communityId.equals(communityId))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Tool?> getTool(String toolId) async {
    final query = _db.select(_db.toolsTable)..where((t) => t.toolId.equals(toolId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsertTool(Tool tool) {
    return _db.into(_db.toolsTable).insertOnConflictUpdate(_toCompanion(tool));
  }

  static Tool _toDomain(ToolRow row) {
    final photoRefs = (jsonDecode(row.photoRefsJson) as List<dynamic>).cast<String>();
    return Tool(
      toolId: row.toolId,
      ownerPubkey: row.ownerPubkey,
      communityId: row.communityId,
      name: row.name,
      category: row.category,
      model: row.model,
      description: row.description,
      photoRefs: photoRefs,
      condition: row.condition,
      status: ToolStatus.values.byName(row.status),
      updatedAt: row.updatedAt.toUtc(),
      schemaVersion: row.schemaVersion,
    );
  }

  static ToolsTableCompanion _toCompanion(Tool tool) {
    return ToolsTableCompanion(
      toolId: Value(tool.toolId),
      ownerPubkey: Value(tool.ownerPubkey),
      communityId: Value(tool.communityId),
      name: Value(tool.name),
      category: Value(tool.category),
      model: Value(tool.model),
      description: Value(tool.description),
      photoRefsJson: Value(jsonEncode(tool.photoRefs)),
      condition: Value(tool.condition),
      status: Value(tool.status.name),
      updatedAt: Value(tool.updatedAt),
      schemaVersion: Value(tool.schemaVersion),
    );
  }
}
