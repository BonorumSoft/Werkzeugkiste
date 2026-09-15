import "package:meta/meta.dart";

import "ids.dart";

/// Mitgliedsstatus innerhalb einer Community (Lastenheft Abschnitt 9).
enum MembershipStatus { active, removed }

@immutable
final class Member {
  const Member({
    required this.pubkey,
    required this.displayName,
    required this.status,
  });

  final Pubkey pubkey;
  final String displayName;
  final MembershipStatus status;

  Map<String, Object?> toJson() => {
        "pubkey": pubkey,
        "display_name": displayName,
        "status": status.name,
      };
}

/// Community-Datensatz (Lastenheft Abschnitt 7).
///
/// `communityKey` wird hier nur als opaker String-Verweis auf das
/// tatsächliche Schlüsselmaterial gehalten – die konkrete Kryptografie
/// (Erzeugung, Rotation) ist Gegenstand von ADR-02 und liegt in der
/// Infrastructure-Schicht, nicht in der Domain (Abschnitt 23: "keine eigene
/// Kryptografie").
@immutable
final class Community {
  const Community({
    required this.communityId,
    required this.communityKeyRef,
    required this.name,
    required this.members,
  });

  final CommunityId communityId;
  final String communityKeyRef;
  final String name;
  final List<Member> members;

  bool hasActiveMember(Pubkey pubkey) => members.any(
        (m) => m.pubkey == pubkey && m.status == MembershipStatus.active,
      );

  /// REQ Abschnitt 9: Verlassen der Community entfernt den Nutzer aus der
  /// LOKALEN Sicht (Mitgliedsstatus -> removed). Das Lastenheft macht
  /// bewusst KEINE Garantie über vollständige kryptografische Rücknahme
  /// bereits verteilter Daten (bekannte MVP-Einschränkung, siehe ADR-02).
  Community withMemberRemoved(Pubkey pubkey) {
    return Community(
      communityId: communityId,
      communityKeyRef: communityKeyRef,
      name: name,
      members: [
        for (final m in members)
          if (m.pubkey == pubkey) Member(pubkey: m.pubkey, displayName: m.displayName, status: MembershipStatus.removed) else m,
      ],
    );
  }

  Map<String, Object?> toJson() => {
        "community_id": communityId,
        "name": name,
        "members": members.map((m) => m.toJson()).toList(),
      };
}
