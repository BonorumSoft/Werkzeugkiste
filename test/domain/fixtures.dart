import "package:werkzeugkiste/domain/tool.dart";

/// Test-Fixtures für die Domain-Testsuite. Zentral gehalten, damit alle
/// Testdateien mit denselben Ausgangsdaten arbeiten (REQ-Traceability
/// bleibt dadurch für Reviewer leichter nachvollziehbar).
const String ownerPubkey = "npub1owner000000000000000000000000000000000000000000000000";
const String otherOwnerPubkey = "npub1other000000000000000000000000000000000000000000000000";
const String borrowerPubkey = "npub1borrower0000000000000000000000000000000000000000000000";
const String secondBorrowerPubkey = "npub1borrower2000000000000000000000000000000000000000000000";
const String communityId = "community-brinkum-001";

final DateTime t0 = DateTime.utc(2026, 9, 12, 18, 42);

Tool buildAvailableTool({
  String toolId = "tool-bohrhammer-001",
  String owner = ownerPubkey,
  DateTime? updatedAt,
}) {
  return Tool(
    toolId: toolId,
    ownerPubkey: owner,
    communityId: communityId,
    name: "Bosch Bohrhammer",
    category: "Elektrowerkzeug",
    status: ToolStatus.available,
    updatedAt: updatedAt ?? t0,
  );
}
