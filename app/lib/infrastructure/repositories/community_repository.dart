/// Persistenz-Adapter für `CommunitiesTable`/`MembersTable` <-> `Community`
/// (`package:werkzeugkiste/domain/community.dart`).
///
/// Ein `Community`-Domain-Objekt bündelt Community-Stammdaten UND die
/// vollständige Mitgliederliste (siehe Domain-Modell) – dieser Repository
/// fasst beide Tabellen entsprechend zusammen. Änderungen an einer der
/// beiden Tabellen lösen ein Neu-Laden aus (`StreamGroup.merge`, siehe
/// `package:async` – bewusst die offizielle, kleine dart-lang-Bibliothek
/// statt einer eigenen Reimplementierung von "combineLatest").
library;

import "package:async/async.dart" show StreamGroup;
import "package:drift/drift.dart";
import "package:werkzeugkiste/domain/community.dart";

import "../database/app_database.dart";

class CommunityRepository {
  CommunityRepository(this._db);

  final AppDatabase _db;

  Stream<List<Community>> watchCommunities() {
    final trigger = StreamGroup.merge<void>([
      _db.select(_db.communitiesTable).watch().map((_) => null),
      _db.select(_db.membersTable).watch().map((_) => null),
    ]);
    return trigger.asyncMap((_) => _fetchAll());
  }

  Future<List<Community>> _fetchAll() async {
    final communities = await _db.select(_db.communitiesTable).get();
    final members = await _db.select(_db.membersTable).get();
    return [
      for (final c in communities)
        _toDomain(c, members.where((m) => m.communityId == c.communityId).toList()),
    ];
  }

  Future<Community?> getCommunity(String communityId) async {
    final communityQuery = _db.select(_db.communitiesTable)..where((c) => c.communityId.equals(communityId));
    final communityRow = await communityQuery.getSingleOrNull();
    if (communityRow == null) return null;
    final membersQuery = _db.select(_db.membersTable)..where((m) => m.communityId.equals(communityId));
    final memberRows = await membersQuery.get();
    return _toDomain(communityRow, memberRows);
  }

  Future<void> upsertCommunity(Community community) async {
    await _db.into(_db.communitiesTable).insertOnConflictUpdate(
          CommunitiesTableCompanion(
            communityId: Value(community.communityId),
            communityKeyRef: Value(community.communityKeyRef),
            name: Value(community.name),
          ),
        );
    for (final member in community.members) {
      await _db.into(_db.membersTable).insertOnConflictUpdate(
            MembersTableCompanion(
              communityId: Value(community.communityId),
              pubkey: Value(member.pubkey),
              displayName: Value(member.displayName),
              status: Value(member.status.name),
            ),
          );
    }
  }

  static Community _toDomain(CommunityRow row, List<MemberRow> memberRows) {
    return Community(
      communityId: row.communityId,
      communityKeyRef: row.communityKeyRef,
      name: row.name,
      members: [
        for (final m in memberRows)
          Member(
            pubkey: m.pubkey,
            displayName: m.displayName,
            status: MembershipStatus.values.byName(m.status),
          ),
      ],
    );
  }
}
