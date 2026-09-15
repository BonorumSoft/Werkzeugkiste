/// Persistenz-Adapter für `InvitesTable` <-> `Invite`
/// (`package:werkzeugkiste/domain/invite.dart`, ADR-03).
library;

import "package:drift/drift.dart";
import "package:werkzeugkiste/domain/invite.dart";

import "../database/app_database.dart";

class InviteRepository {
  InviteRepository(this._db);

  final AppDatabase _db;

  Stream<List<Invite>> watchInvitesForCommunity(String communityId) {
    final query = _db.select(_db.invitesTable)
      ..where((i) => i.communityId.equals(communityId))
      ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Invite?> getInvite(String inviteId) async {
    final query = _db.select(_db.invitesTable)..where((i) => i.inviteId.equals(inviteId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Sucht eine bekannte Einladung anhand ihres Token-Hashes. In dieser
  /// noch rein lokalen (Nostr-losen) Betriebsart kann ein Gerät nur
  /// Einladungen einlösen, die es selbst kennt (siehe README/ARCHITECTURE:
  /// Mehrgeräte-Verteilung ist Aufgabe der noch nicht implementierten
  /// Nostr-Anbindung, ADR-01/02/08).
  Future<Invite?> findByTokenHash(String tokenHash) async {
    final query = _db.select(_db.invitesTable)..where((i) => i.tokenHash.equals(tokenHash));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsertInvite(Invite invite) {
    return _db.into(_db.invitesTable).insertOnConflictUpdate(_toCompanion(invite));
  }

  static Invite _toDomain(InviteRow row) {
    return Invite(
      inviteId: row.inviteId,
      communityId: row.communityId,
      createdByPubkey: row.createdByPubkey,
      tokenHash: row.tokenHash,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
      status: InviteStatus.values.byName(row.status),
      consumedByPubkey: row.consumedByPubkey,
      consumedAt: row.consumedAt,
      schemaVersion: row.schemaVersion,
    );
  }

  static InvitesTableCompanion _toCompanion(Invite invite) {
    return InvitesTableCompanion(
      inviteId: Value(invite.inviteId),
      communityId: Value(invite.communityId),
      createdByPubkey: Value(invite.createdByPubkey),
      tokenHash: Value(invite.tokenHash),
      createdAt: Value(invite.createdAt),
      expiresAt: Value(invite.expiresAt),
      status: Value(invite.status.name),
      consumedByPubkey: Value(invite.consumedByPubkey),
      consumedAt: Value(invite.consumedAt),
      schemaVersion: Value(invite.schemaVersion),
    );
  }
}
