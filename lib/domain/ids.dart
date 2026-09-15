/// Typalias für die verschiedenen ID-/Schlüssel-Konzepte der Domain.
///
/// Bewusst als einfache String-Aliase gehalten (keine externen Typen),
/// damit die Domain-Schicht frei von Infrastruktur-Abhängigkeiten bleibt
/// (Lastenheft Abschnitt 35/36).
library;

/// Der Public Key eines Nutzers – dient als technische Identität
/// (Lastenheft Abschnitt 5.1).
typedef Pubkey = String;

/// Eindeutige ID einer Community (Lastenheft Abschnitt 7).
typedef CommunityId = String;

/// Eindeutige ID eines Werkzeugs (Lastenheft Abschnitt 10).
typedef ToolId = String;

/// Eindeutige ID einer Leihanfrage (Lastenheft Abschnitt 11).
typedef LoanRequestId = String;

/// Eindeutige ID eines Leihvorgangs (Lastenheft Abschnitt 12).
typedef LoanId = String;

/// Eindeutige ID eines technischen Events (Lastenheft Abschnitt 38).
typedef EventId = String;

/// Eindeutige ID einer Einladung (ADR-03, `docs/adr/0003-invite-system.md`).
typedef InviteId = String;
