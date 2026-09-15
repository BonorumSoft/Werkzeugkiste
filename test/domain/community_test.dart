// Traceability: REQ zu Community-Mitgliedschaft (Abschnitt 7/9). Diese
// Datei existierte bislang nicht – lib/domain/community.dart wurde in
// Phase 4 implementiert, aber nie durch eine eigene Testdatei abgesichert
// (siehe reports/phase6_mutation.md, Fund MUT-EQ-COMMUNITY: kein Test hätte
// eine Regression hier bemerkt). Wird hier nachgezogen, bevor die
// Mutationstests dagegen laufen.
import "package:test/test.dart";
import "package:werkzeugkiste/domain/community.dart";

void main() {
  group("Community (Abschnitt 7/9)", () {
    test("hasActiveMember: true für aktives Mitglied", () {
      final community = Community(
        communityId: "community-1",
        communityKeyRef: "key-ref-1",
        name: "Nachbarschaft Nord",
        members: const [
          Member(pubkey: "pk-a", displayName: "A", status: MembershipStatus.active),
        ],
      );
      expect(community.hasActiveMember("pk-a"), isTrue);
    });

    test("hasActiveMember: false für unbekannten Pubkey", () {
      final community = Community(
        communityId: "community-1",
        communityKeyRef: "key-ref-1",
        name: "Nachbarschaft Nord",
        members: const [],
      );
      expect(community.hasActiveMember("pk-unbekannt"), isFalse);
    });

    test("hasActiveMember: false für entferntes Mitglied (Abschnitt 9)", () {
      final community = Community(
        communityId: "community-1",
        communityKeyRef: "key-ref-1",
        name: "Nachbarschaft Nord",
        members: const [
          Member(pubkey: "pk-a", displayName: "A", status: MembershipStatus.removed),
        ],
      );
      expect(community.hasActiveMember("pk-a"), isFalse);
    });

    test(
      "withMemberRemoved setzt Status auf removed, lässt andere Mitglieder unverändert "
      "(Abschnitt 9: Verlassen = lokale Statusänderung, kein Löschen)",
      () {
        final community = Community(
          communityId: "community-1",
          communityKeyRef: "key-ref-1",
          name: "Nachbarschaft Nord",
          members: const [
            Member(pubkey: "pk-a", displayName: "A", status: MembershipStatus.active),
            Member(pubkey: "pk-b", displayName: "B", status: MembershipStatus.active),
          ],
        );

        final updated = community.withMemberRemoved("pk-a");

        expect(updated.hasActiveMember("pk-a"), isFalse);
        expect(updated.hasActiveMember("pk-b"), isTrue);
        expect(updated.members.length, 2);
      },
    );

    test("toJson() enthält community_id, name und alle Mitglieder", () {
      final community = Community(
        communityId: "community-1",
        communityKeyRef: "key-ref-1",
        name: "Nachbarschaft Nord",
        members: const [
          Member(pubkey: "pk-a", displayName: "A", status: MembershipStatus.active),
        ],
      );
      final json = community.toJson();
      expect(json["community_id"], "community-1");
      expect(json["name"], "Nachbarschaft Nord");
      expect((json["members"] as List).length, 1);
    });

    test("Member.toJson() enthält pubkey, display_name und status", () {
      const member = Member(pubkey: "pk-a", displayName: "A", status: MembershipStatus.active);
      final json = member.toJson();
      expect(json["pubkey"], "pk-a");
      expect(json["display_name"], "A");
      expect(json["status"], "active");
    });
  });
}
