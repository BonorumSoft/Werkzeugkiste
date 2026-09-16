/// Persistenz-Adapter für `LoanRequestsTable` <-> `LoanRequest`
/// (`package:werkzeugkiste/domain/loan_request.dart`).
library;

import "package:drift/drift.dart";
import "package:werkzeugkiste/domain/loan_request.dart";

import "../database/app_database.dart";

class LoanRequestRepository {
  LoanRequestRepository(this._db);

  final AppDatabase _db;

  Stream<List<LoanRequest>> watchRequestsForCommunity(String communityId) {
    final query = _db.select(_db.loanRequestsTable)
      ..where((r) => r.communityId.equals(communityId))
      ..orderBy([(r) => OrderingTerm.desc(r.requestedAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<LoanRequest>> getActiveRequestsForTool(String toolId) async {
    final query = _db.select(_db.loanRequestsTable)
      ..where((r) => r.toolId.equals(toolId) & r.status.equals(LoanRequestStatus.pending.name));
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  Future<LoanRequest?> getRequest(String requestId) async {
    final query = _db.select(_db.loanRequestsTable)..where((r) => r.requestId.equals(requestId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsertRequest(LoanRequest request) {
    return _db.into(_db.loanRequestsTable).insertOnConflictUpdate(_toCompanion(request));
  }

  static LoanRequest _toDomain(LoanRequestRow row) {
    return LoanRequest(
      requestId: row.requestId,
      toolId: row.toolId,
      communityId: row.communityId,
      requesterPubkey: row.requesterPubkey,
      ownerPubkey: row.ownerPubkey,
      requestedAt: row.requestedAt.toUtc(),
      status: LoanRequestStatus.values.byName(row.status),
      schemaVersion: row.schemaVersion,
    );
  }

  static LoanRequestsTableCompanion _toCompanion(LoanRequest request) {
    return LoanRequestsTableCompanion(
      requestId: Value(request.requestId),
      toolId: Value(request.toolId),
      communityId: Value(request.communityId),
      requesterPubkey: Value(request.requesterPubkey),
      ownerPubkey: Value(request.ownerPubkey),
      requestedAt: Value(request.requestedAt),
      status: Value(request.status.name),
      schemaVersion: Value(request.schemaVersion),
    );
  }
}
