import "package:meta/meta.dart";

import "exceptions.dart";
import "ids.dart";

/// Zustand eines Leihvorgangs (Lastenheft Abschnitt 12/13/14).
enum LoanStatus { active, completed }

/// Leihvorgang-Datensatz (Lastenheft Abschnitt 12).
///
/// GUARD (Abschnitt 12): Dieses Modell besitzt bewusst KEIN Feld `lent_at`
/// und KEIN Feld `expected_return_at`. `acceptedAt` markiert zugleich den
/// Beginn der Ausleihe – es gibt keinen separaten Übergabezeitpunkt.
@immutable
final class Loan {
  const Loan({
    required this.loanId,
    required this.toolId,
    required this.communityId,
    required this.ownerPubkey,
    required this.borrowerPubkey,
    required this.requestedAt,
    required this.acceptedAt,
    required this.status,
    this.returnedAt,
    this.schemaVersion = 1,
  }) : assert(
          (status == LoanStatus.completed) == (returnedAt != null),
          "returnedAt muss genau dann gesetzt sein, wenn status == completed",
        );

  final LoanId loanId;
  final ToolId toolId;
  final CommunityId communityId;
  final Pubkey ownerPubkey;
  final Pubkey borrowerPubkey;
  final DateTime requestedAt;

  /// Zeitpunkt der Eigentümer-Bestätigung UND Beginn der Ausleihe
  /// (Abschnitt 12: "Bestätigung = Beginn der Ausleihe").
  final DateTime acceptedAt;

  /// Zeitpunkt der vom Eigentümer bestätigten Rückgabe, `null` solange aktiv.
  final DateTime? returnedAt;

  final LoanStatus status;
  final int schemaVersion;

  bool get isActive => status == LoanStatus.active;

  /// REQ Abschnitt 14: Rückgabebestätigung setzt returnedAt, Status
  /// COMPLETED. Nur aus [LoanStatus.active] heraus zulässig.
  Loan withReturnConfirmed(DateTime returnedAt) {
    if (status != LoanStatus.active) {
      throw InvalidStateTransition(status, LoanStatus.completed, "Loan ist nicht aktiv");
    }
    return Loan(
      loanId: loanId,
      toolId: toolId,
      communityId: communityId,
      ownerPubkey: ownerPubkey,
      borrowerPubkey: borrowerPubkey,
      requestedAt: requestedAt,
      acceptedAt: acceptedAt,
      returnedAt: returnedAt,
      status: LoanStatus.completed,
      schemaVersion: schemaVersion,
    );
  }

  Map<String, Object?> toJson() => {
        "loan_id": loanId,
        "tool_id": toolId,
        "community_id": communityId,
        "owner_pubkey": ownerPubkey,
        "borrower_pubkey": borrowerPubkey,
        "requested_at": requestedAt.toIso8601String(),
        "accepted_at": acceptedAt.toIso8601String(),
        "returned_at": returnedAt?.toIso8601String(),
        "status": status.name,
        "schema_version": schemaVersion,
      };
}
