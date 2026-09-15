/// Lokale SQLite-Datenbank (ADR-07) über `package:drift`.
///
/// Öffnet die Datei `werkzeugkiste.sqlite` im App-Dokumentenverzeichnis.
///
/// GUARD (ADR-07): Verschlüsselung (SQLCipher) ist in ADR-07 als
/// Ziel-Betriebsart entschieden, aber in diesem Schritt bewusst NICHT
/// umgesetzt – das erfordert `sqlcipher_flutter_libs` statt
/// `sqlite3_flutter_libs` sowie eine sichere Passwort-Erzeugung/-Ablage
/// (siehe [DeviceIdentityStore] für das analoge, noch offene
/// Schlüsselmaterial-Thema). Diese Lücke ist bewusst offen dokumentiert statt
/// stillschweigend übergangen (Projekt-Grundsatz: keine unbelegten
/// Behauptungen).
library;

import "dart:io";

import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";
import "package:sqlite3/sqlite3.dart";

import "tables.dart";

part "app_database.g.dart";

@DriftDatabase(
  tables: [
    ToolsTable,
    LoanRequestsTable,
    LoansTable,
    CommunitiesTable,
    MembersTable,
    InvitesTable,
    LocalIdentityTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Für Tests: rein speicherresidente Datenbank, kein Dateisystemzugriff.
  factory AppDatabase.forTesting() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dir.path, "werkzeugkiste.sqlite"));
      return NativeDatabase.createInBackground(dbFile, setup: (db) {
        // Fremdschlüssel/Pragmas absichtlich minimal gehalten – die Domain-
        // Schicht ist die alleinige Quelle für Integritätsregeln
        // (Zustandsautomaten, Berechtigungen), nicht die DB (Abschnitt 36).
        db.execute("PRAGMA journal_mode=WAL;");
      });
    });
  }
}

/// Reicht `sqlite3`-Bibliothek für native Plattformen nach, falls nötig
/// (auf iOS/Android durch `sqlite3_flutter_libs` bereitgestellt, auf
/// Desktop/CI-Hosts i. d. R. bereits systemseitig vorhanden).
void ensureSqlite3Available() {
  try {
    sqlite3.version;
  } catch (_) {
    // Best-effort: keine harte Fehlerbehandlung hier, das eigentliche Öffnen
    // der Datenbank liefert im Fehlerfall eine aussagekräftige Exception.
  }
}
