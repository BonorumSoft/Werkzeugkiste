// Traceability: REQ-071/REQ-072 (Abschnitt 10.1 – nur Eigentümer darf
// bearbeiten/löschen), REQ-Security (Abschnitt 33 "Berechtigungsprüfung in
// der Domain-Schicht").
import "package:test/test.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/tool.dart";
import "package:werkzeugkiste/domain/tool_service.dart";

import "fixtures.dart";

void main() {
  group("Berechtigungen auf Tool (Abschnitt 10.1)", () {
    test("Eigentümer B kann Tool von A NICHT bearbeiten", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      expect(
        () => updateTool(tool, actor: otherOwnerPubkey, name: "Manipuliert", now: t0),
        throwsA(isA<PermissionDenied>()),
      );
    });

    test("Eigentümer B kann Tool von A NICHT löschen", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      expect(
        () => deleteTool(tool, actor: otherOwnerPubkey, now: t0),
        throwsA(isA<PermissionDenied>()),
      );
    });

    test("Der tatsächliche Eigentümer kann sein Werkzeug bearbeiten", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      final updated = updateTool(tool, actor: ownerPubkey, name: "Neuer Name", now: t0);
      expect(updated.name, "Neuer Name");
    });

    test("Der tatsächliche Eigentümer kann sein verfügbares Werkzeug löschen", () {
      final tool = buildAvailableTool(owner: ownerPubkey);
      final deleted = deleteTool(tool, actor: ownerPubkey, now: t0);
      expect(deleted.status, ToolStatus.deleted);
    });
  });
}
