// End-zu-Ende-Test der Application-Schicht (kein UI): zwei simulierte
// Geräte (eigene Identität je Provider-Container, gemeinsame In-Memory-DB)
// durchlaufen den vollständigen Leihzyklus aus dem Akzeptanzszenario
// (Lastenheft Abschnitt 48): Werkzeug anlegen -> Ausleihe anfragen ->
// annehmen -> Rückgabe bestätigen.

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:werkzeugkiste/domain/loan.dart";
import "package:werkzeugkiste/domain/loan_request.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste_app/application/community_controller.dart";
import "package:werkzeugkiste_app/application/database_providers.dart";
import "package:werkzeugkiste_app/application/identity_controller.dart";
import "package:werkzeugkiste_app/application/loan_workflow_controller.dart";
import "package:werkzeugkiste_app/infrastructure/database/app_database.dart";

import "../fakes.dart";

void main() {
  test("vollständiger Leihzyklus über zwei simulierte Geräte", () async {
    final sharedDb = AppDatabase.forTesting();
    addTearDown(sharedDb.close);

    final ownerContainer = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(sharedDb),
      identityStoreProvider.overrideWithValue(FakeIdentityStore()),
    ]);
    addTearDown(ownerContainer.dispose);
    final borrowerContainer = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(sharedDb),
      identityStoreProvider.overrideWithValue(FakeIdentityStore()),
    ]);
    addTearDown(borrowerContainer.dispose);

    await ownerContainer.read(identityControllerProvider.notifier).createIdentity("Eigentümer");
    await borrowerContainer.read(identityControllerProvider.notifier).createIdentity("Ausleiher");
    final ownerPubkey = ownerContainer.read(identityControllerProvider).value!.pubkey;
    final borrowerPubkey = borrowerContainer.read(identityControllerProvider).value!.pubkey;
    expect(ownerPubkey, isNot(equals(borrowerPubkey)));

    final community = await ownerContainer.read(communityControllerProvider).createCommunity("Testviertel");

    final tool = await ownerContainer.read(loanWorkflowControllerProvider).createTool(
          communityId: community.communityId,
          name: "Akkuschrauber",
          category: "Elektrowerkzeug",
        );
    expect(tool.status, ToolStatus.available);
    expect(tool.ownerPubkey, ownerPubkey);

    // Ausleiher stellt Anfrage (liest das Tool über die eigene DB-Sicht,
    // die dieselbe geteilte In-Memory-Datenbank verwendet).
    final toolForBorrower = await borrowerContainer.read(toolRepositoryProvider).getTool(tool.toolId);
    await borrowerContainer.read(loanWorkflowControllerProvider).requestLoan(toolForBorrower!);

    final requestsAfterRequest = await ownerContainer.read(loanRequestRepositoryProvider).getActiveRequestsForTool(
          tool.toolId,
        );
    expect(requestsAfterRequest, hasLength(1));
    final request = requestsAfterRequest.single;
    expect(request.requesterPubkey, borrowerPubkey);
    expect(request.status, LoanRequestStatus.pending);

    final toolAfterRequest = await ownerContainer.read(toolRepositoryProvider).getTool(tool.toolId);
    expect(toolAfterRequest!.status, ToolStatus.requested);

    // Ein zweiter Ausleihversuch für dasselbe Werkzeug muss an der
    // Domain-Regel "max. eine aktive Anfrage pro Werkzeug" scheitern.
    expect(
      () => ownerContainer.read(loanWorkflowControllerProvider).requestLoan(toolAfterRequest),
      throwsA(isA<Exception>()),
    );

    // Eigentümer nimmt die Anfrage an.
    await ownerContainer.read(loanWorkflowControllerProvider).acceptLoanRequest(toolAfterRequest, request);

    final toolAfterAccept = await ownerContainer.read(toolRepositoryProvider).getTool(tool.toolId);
    expect(toolAfterAccept!.status, ToolStatus.loaned);

    final loans = await borrowerContainer.read(loanRepositoryProvider).watchLoansForCommunity(
          community.communityId,
        ).first;
    expect(loans, hasLength(1));
    final loan = loans.single;
    expect(loan.status, LoanStatus.active);
    expect(loan.borrowerPubkey, borrowerPubkey);

    // Eigentümer bestätigt die Rückgabe.
    await ownerContainer.read(loanWorkflowControllerProvider).confirmReturn(toolAfterAccept, loan);

    final toolAfterReturn = await ownerContainer.read(toolRepositoryProvider).getTool(tool.toolId);
    expect(toolAfterReturn!.status, ToolStatus.available);
    final loanAfterReturn = await ownerContainer.read(loanRepositoryProvider).getLoan(loan.loanId);
    expect(loanAfterReturn!.status, LoanStatus.completed);
    expect(loanAfterReturn.returnedAt, isNotNull);
  });

  test("Einladung: erstellen und auf demselben Gerät wieder einlösen scheitert erwartungsgemäß "
      "an 'bereits aktives Mitglied' nicht, sondern läuft durch (Domain erlaubt Re-Redemption-Versuch "
      "nur einmal, siehe InvalidStateTransition bei zweitem Versuch)", () async {
    final sharedDb = AppDatabase.forTesting();
    addTearDown(sharedDb.close);
    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(sharedDb),
      identityStoreProvider.overrideWithValue(FakeIdentityStore()),
    ]);
    addTearDown(container.dispose);

    await container.read(identityControllerProvider.notifier).createIdentity("Ersteller");
    final community = await container.read(communityControllerProvider).createCommunity("Testviertel 2");
    final created = await container.read(communityControllerProvider).createInvite(community.communityId);

    final redeemed = await container.read(communityControllerProvider).redeemInvite(created.plaintextToken);
    expect(redeemed.inviteId, created.invite.inviteId);

    // Zweiter Einlöseversuch mit demselben Token muss fehlschlagen, da die
    // Einladung bereits im Zustand "consumed" ist (State-Machine erlaubt
    // keinen erneuten Übergang consumed -> consumed, siehe invite.dart).
    expect(
      () => container.read(communityControllerProvider).redeemInvite(created.plaintextToken),
      throwsA(isA<Exception>()),
    );
  });
}
