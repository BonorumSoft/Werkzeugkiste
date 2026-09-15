/// Drift-Tabellendefinitionen für die lokale SQLite-Datenbank (ADR-07,
/// `docs/adr/0007-lokale-datenbank.md`).
///
/// WICHTIG: Diese Tabellen sind reine Persistenz-Spiegelbilder der
/// Domain-Entitäten aus `package:werkzeugkiste/domain/*`. Sie enthalten
/// bewusst keine eigene Geschäftslogik – die lebt ausschließlich in der
/// Domain-Schicht (Abschnitt 36). Die Drift-Schema-Version (siehe
/// [AppDatabase.schemaVersion]) ist unabhängig vom `schemaVersion`-Feld der
/// Domain-Entitäten selbst zu zählen (siehe ADR-07, Abschnitt "Migrationen").
library;

import "package:drift/drift.dart";

/// Werkzeuge (Lastenheft Abschnitt 10).
@DataClassName("ToolRow")
class ToolsTable extends Table {
  TextColumn get toolId => text()();
  TextColumn get ownerPubkey => text()();
  TextColumn get communityId => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get model => text().nullable()();
  TextColumn get description => text().nullable()();

  /// JSON-kodierte Liste von SHA-256-Foto-Hashes (ADR-05).
  TextColumn get photoRefsJson => text().withDefault(const Constant("[]"))();
  TextColumn get condition => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {toolId};
}

/// Leihanfragen (Lastenheft Abschnitt 11).
@DataClassName("LoanRequestRow")
class LoanRequestsTable extends Table {
  TextColumn get requestId => text()();
  TextColumn get toolId => text()();
  TextColumn get communityId => text()();
  TextColumn get requesterPubkey => text()();
  TextColumn get ownerPubkey => text()();
  DateTimeColumn get requestedAt => dateTime()();
  TextColumn get status => text()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {requestId};
}

/// Leihvorgänge (Lastenheft Abschnitt 12-14).
@DataClassName("LoanRow")
class LoansTable extends Table {
  TextColumn get loanId => text()();
  TextColumn get toolId => text()();
  TextColumn get communityId => text()();
  TextColumn get ownerPubkey => text()();
  TextColumn get borrowerPubkey => text()();
  DateTimeColumn get requestedAt => dateTime()();
  DateTimeColumn get acceptedAt => dateTime()();
  DateTimeColumn get returnedAt => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {loanId};
}

/// Communities (Lastenheft Abschnitt 7).
@DataClassName("CommunityRow")
class CommunitiesTable extends Table {
  TextColumn get communityId => text()();
  TextColumn get communityKeyRef => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {communityId};
}

/// Mitgliedschaften (Lastenheft Abschnitt 9) – (communityId, pubkey) ist der
/// zusammengesetzte Primärschlüssel, da ein Pubkey in mehreren Communities
/// Mitglied sein kann.
@DataClassName("MemberRow")
class MembersTable extends Table {
  TextColumn get communityId => text()();
  TextColumn get pubkey => text()();
  TextColumn get displayName => text()();
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {communityId, pubkey};
}

/// Einladungen (ADR-03, `docs/adr/0003-invite-system.md`).
@DataClassName("InviteRow")
class InvitesTable extends Table {
  TextColumn get inviteId => text()();
  TextColumn get communityId => text()();
  TextColumn get createdByPubkey => text()();
  TextColumn get tokenHash => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  TextColumn get status => text()();
  TextColumn get consumedByPubkey => text().nullable()();
  DateTimeColumn get consumedAt => dateTime().nullable()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {inviteId};
}

/// Lokale Geräte-Identität (ADR-06/07). Genau eine Zeile (id = 1).
///
/// WICHTIG (ehrliche Abgrenzung, siehe README/ARCHITECTURE): `pubkey` ist
/// hier ein lokal zufällig erzeugter Platzhalter-String, KEIN echter
/// secp256k1-/Nostr-Schlüssel. Die echte Schlüsselerzeugung/-verwaltung ist
/// Teil der noch nicht implementierten Nostr-Anbindung (ADR-01/ADR-06).
@DataClassName("LocalIdentityRow")
class LocalIdentityTable extends Table {
  IntColumn get id => integer()();
  TextColumn get pubkey => text()();
  TextColumn get displayName => text()();

  @override
  Set<Column> get primaryKey => {id};
}
