/// Persistenz-Adapter für `LoansTable` <-> `Loan`
/// (`package:werkzeugkiste/domain/loan.dart`).
library;

import "package:drift/drift.dart";
import "package:werkzeugkiste/domain/loan.dart";

import "../database/app_database.dart";

class LoanRepository {
  LoanRepository(this._db);

  final AppDatabase _db;

  Stream<List<Loan>> watchLoansForCommunity(String communityId) {
    final query = _db.select(_db.loansTable)
      ..where((l) => l.communityId.equals(communityId))
      ..orderBy([(l) => OrderingTerm.desc(l.acceptedAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Loan?> getLoan(String loanId) async {
    final query = _db.select(_db.loansTable)..where((l) => l.loanId.equals(loanId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsertLoan(Loan loan) {
    return _db.into(_db.loansTable).insertOnConflictUpdate(_toCompanion(loan));
  }

  static Loan _toDomain(LoanRow row) {
    return Loan(
      loanId: row.loanId,
      toolId: row.toolId,
      communityId: row.communityId,
      ownerPubkey: row.ownerPubkey,
      borrowerPubkey: row.borrowerPubkey,
      requestedAt: row.requestedAt,
      acceptedAt: row.acceptedAt,
      returnedAt: row.returnedAt,
      status: LoanStatus.values.byName(row.status),
      schemaVersion: row.schemaVersion,
    );
  }

  static LoansTableCompanion _toCompanion(Loan loan) {
    return LoansTableCompanion(
      loanId: Value(loan.loanId),
      toolId: Value(loan.toolId),
      communityId: Value(loan.communityId),
      ownerPubkey: Value(loan.ownerPubkey),
      borrowerPubkey: Value(loan.borrowerPubkey),
      requestedAt: Value(loan.requestedAt),
      acceptedAt: Value(loan.acceptedAt),
      returnedAt: Value(loan.returnedAt),
      status: Value(loan.status.name),
      schemaVersion: Value(loan.schemaVersion),
    );
  }
}
