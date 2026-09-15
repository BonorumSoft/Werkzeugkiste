import "package:meta/meta.dart";

import "exceptions.dart";
import "ids.dart";

/// Zustand einer Leihanfrage (Lastenheft Abschnitt 11).
enum LoanRequestStatus { pending, accepted, rejected, cancelled }

const Map<LoanRequestStatus, Set<LoanRequestStatus>> _allowedRequestTransitions = {
  LoanRequestStatus.pending: {
    LoanRequestStatus.accepted,
    LoanRequestStatus.rejected,
    LoanRequestStatus.cancelled,
  },
  LoanRequestStatus.accepted: {},
  LoanRequestStatus.rejected: {},
  LoanRequestStatus.cancelled: {},
};

bool isValidLoanRequestTransition(LoanRequestStatus from, LoanRequestStatus to) {
  return _allowedRequestTransitions[from]?.contains(to) ?? false;
}

void assertValidLoanRequestTransition(LoanRequestStatus from, LoanRequestStatus to) {
  if (!isValidLoanRequestTransition(from, to)) {
    throw InvalidStateTransition(from, to);
  }
}

/// Leihanfrage-Datensatz (Lastenheft Abschnitt 11).
@immutable
final class LoanRequest {
  const LoanRequest({
    required this.requestId,
    required this.toolId,
    required this.communityId,
    required this.requesterPubkey,
    required this.ownerPubkey,
    required this.requestedAt,
    required this.status,
    this.schemaVersion = 1,
  });

  final LoanRequestId requestId;
  final ToolId toolId;
  final CommunityId communityId;
  final Pubkey requesterPubkey;
  final Pubkey ownerPubkey;
  final DateTime requestedAt;
  final LoanRequestStatus status;
  final int schemaVersion;

  bool get isActive => status == LoanRequestStatus.pending;

  LoanRequest withStatus(LoanRequestStatus newStatus) {
    assertValidLoanRequestTransition(status, newStatus);
    return LoanRequest(
      requestId: requestId,
      toolId: toolId,
      communityId: communityId,
      requesterPubkey: requesterPubkey,
      ownerPubkey: ownerPubkey,
      requestedAt: requestedAt,
      status: newStatus,
      schemaVersion: schemaVersion,
    );
  }

  Map<String, Object?> toJson() => {
        "request_id": requestId,
        "tool_id": toolId,
        "community_id": communityId,
        "requester_pubkey": requesterPubkey,
        "owner_pubkey": ownerPubkey,
        "requested_at": requestedAt.toIso8601String(),
        "status": status.name,
        "schema_version": schemaVersion,
      };
}
