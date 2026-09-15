/// Riverpod-Provider für Datenbank, Repositories und sonstige
/// Infrastruktur-Services (Application-Schicht, Lastenheft Abschnitt 36).
library;

import "package:flutter_riverpod/flutter_riverpod.dart";

import "../infrastructure/database/app_database.dart";
import "../infrastructure/id_generator.dart";
import "../infrastructure/identity_store.dart";
import "../infrastructure/photo_storage.dart";
import "../infrastructure/repositories/community_repository.dart";
import "../infrastructure/repositories/invite_repository.dart";
import "../infrastructure/repositories/loan_repository.dart";
import "../infrastructure/repositories/loan_request_repository.dart";
import "../infrastructure/repositories/tool_repository.dart";

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final toolRepositoryProvider = Provider<ToolRepository>((ref) {
  return ToolRepository(ref.watch(databaseProvider));
});

final loanRequestRepositoryProvider = Provider<LoanRequestRepository>((ref) {
  return LoanRequestRepository(ref.watch(databaseProvider));
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepository(ref.watch(databaseProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(databaseProvider));
});

final inviteRepositoryProvider = Provider<InviteRepository>((ref) {
  return InviteRepository(ref.watch(databaseProvider));
});

final photoStorageProvider = Provider<PhotoStorage>((ref) => PhotoStorage());

final idGeneratorProvider = Provider<IdGenerator>((ref) => const IdGenerator());

final identityStoreProvider = Provider<IdentityStore>((ref) => IdentityStore());
