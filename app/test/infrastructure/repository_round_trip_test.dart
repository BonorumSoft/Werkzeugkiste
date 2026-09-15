// Verifiziert, dass jede Repository-Klasse Domain-Entitäten verlustfrei in
// die lokale SQLite-Datenbank schreibt und wieder ausliest (Mapping-Fehler
// wie vertauschte Enum-Namen oder vergessene Felder wären hier sichtbar).

import "package:flutter_test/flutter_test.dart";
import "package:werkzeugkiste/domain/community.dart";
import "package:werkzeugkiste/domain/invite.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste_app/infrastructure/database/app_database.dart";
import "package:werkzeugkiste_app/infrastructure/repositories/community_repository.dart";
import "package:werkzeugkiste_app/infrastructure/repositories/invite_repository.dart";
import "package:werkzeugkiste_app/infrastructure/repositories/loan_repository.dart";
import "package:werkzeugkiste_app/infrastructure/repositories/loan_request_repository.dart";
import "package:werkzeugkiste_app/infrastructure/repositories/tool_repository.dart";

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting();
  });

  tearDown(() async {
    await db.close();
  });

  test("ToolRepository: Round-Trip erhält alle Felder inkl. photoRefs", () async {
    final repo = ToolRepository(db);
    final tool = Tool(
      toolId: "tool-1",
      ownerPubkey: "owner-1",
      communityId: "community-1",
      name: "Bohrmaschine",
      category: "Elektrowerkzeug",
      model: "PSB 500",
      description: "Mit Schlagbohrfunktion",
      photoRefs: const ["hash-a", "hash-b"],
      condition: "gut",
      status: ToolStatus.requested,
      updatedAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
    );

    await repo.upsertTool(tool);
    final loaded = await repo.getTool("tool-1");

    expect(loaded, isNotNull);
    expect(loaded!.toJson(), tool.toJson());
  });

  test("LoanRequestRepository: getActiveRequestsForTool filtert nach status pending", () async {
    final repo = LoanRequestRepository(db);
    final pending = LoanRequest(
      requestId: "req-1",
      toolId: "tool-1",
      communityId: "community-1",
      requesterPubkey: "borrower-1",
      ownerPubkey: "owner-1",
      requestedAt: DateTime.utc(2026),
      status: LoanRequestStatus.pending,
    );
    final cancelled = pending.withStatus(LoanRequestStatus.cancelled);

    await repo.upsertRequest(pending);
    await repo.upsertRequest(cancelled.copyWithId("req-2"));

    final active = await repo.getActiveRequestsForTool("tool-1");
    expect(active, hasLength(1));
    expect(active.single.requestId, "req-1");
  });

  test("LoanRepository: Round-Trip erhält returnedAt/null korrekt", () async {
    final repo = LoanRepository(db);
    final active = Loan(
      loanId: "loan-1",
      toolId: "tool-1",
      communityId: "community-1",
      ownerPubkey: "owner-1",
      borrowerPubkey: "borrower-1",
      requestedAt: DateTime.utc(2026, 1, 1),
      acceptedAt: DateTime.utc(2026, 1, 2),
      status: LoanStatus.active,
    );
    await repo.upsertLoan(active);
    final loadedActive = await repo.getLoan("loan-1");
    expect(loadedActive!.returnedAt, isNull);

    final completed = active.withReturnConfirmed(DateTime.utc(2026, 1, 10));
    await repo.upsertLoan(completed);
    final loadedCompleted = await repo.getLoan("loan-1");
    expect(loadedCompleted!.returnedAt, DateTime.utc(2026, 1, 10));
    expect(loadedCompleted.status, LoanStatus.completed);
  });

  test("CommunityRepository: speichert Community inkl. Mitgliederliste", () async {
    final repo = CommunityRepository(db);
    final community = Community(
      communityId: "community-1",
      communityKeyRef: "key-ref-1",
      name: "Nachbarschaft",
      members: const [
        Member(pubkey: "owner-1", displayName: "Alex", status: MembershipStatus.active),
        Member(pubkey: "owner-2", displayName: "Sam", status: MembershipStatus.removed),
      ],
    );
    await repo.upsertCommunity(community);

    final loaded = await repo.getCommunity("community-1");
    expect(loaded, isNotNull);
    expect(loaded!.members, hasLength(2));
    expect(loaded.hasActiveMember("owner-1"), isTrue);
    expect(loaded.hasActiveMember("owner-2"), isFalse);
  });

  test("InviteRepository: findByTokenHash findet eine erzeugte Einladung", () async {
    final repo = InviteRepository(db);
    final invite = Invite(
      inviteId: "invite-1",
      communityId: "community-1",
      createdByPubkey: "owner-1",
      tokenHash: "hash-of-token",
      createdAt: DateTime.utc(2026, 1, 1),
      expiresAt: DateTime.utc(2026, 1, 8),
      status: InviteStatus.pending,
    );
    await repo.upsertInvite(invite);

    final found = await repo.findByTokenHash("hash-of-token");
    expect(found, isNotNull);
    expect(found!.inviteId, "invite-1");

    final notFound = await repo.findByTokenHash("unknown-hash");
    expect(notFound, isNull);
  });
}

extension on LoanRequest {
  /// Test-Hilfsfunktion: erzeugt eine Kopie mit anderer ID (für den
  /// Duplicate-Key-freien Zweit-Datensatz im "aktive Anfragen"-Test).
  LoanRequest copyWithId(String newId) {
    return LoanRequest(
      requestId: newId,
      toolId: toolId,
      communityId: communityId,
      requesterPubkey: requesterPubkey,
      ownerPubkey: ownerPubkey,
      requestedAt: requestedAt,
      status: status,
    );
  }
}
