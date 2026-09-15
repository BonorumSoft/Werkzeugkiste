/// Fachliches Event-Modell (Lastenheft Abschnitt 38).
///
/// Dies ist ein STRUKTURELLES Skelett für die Domain-Grenze. Die konkrete
/// Nostr-/NIP-Bindung, Signaturerzeugung und -prüfung (echte Kryptografie)
/// ist Aufgabe der Infrastructure-Schicht und Gegenstand von ADR-01
/// (siehe pipeline/00_offene_fragen.md) – die Domain-Schicht selbst
/// implementiert laut Abschnitt 23 „keine eigene Kryptografie", sondern
/// definiert nur die Struktur, die eine Signatur tragen MUSS.
library;

import "ids.dart";

/// Abstrakte Basis aller fachlichen Events (Abschnitt 38).
///
/// Jedes Event benötigt eine eindeutige [eventId] und muss laut Abschnitt 38
/// „kryptografisch authentifiziert" sein – hier abgebildet durch die
/// Pflichtfelder [signerPubkey] und [signature], deren tatsächliche
/// kryptografische Prüfung außerhalb der Domain-Schicht erfolgt.
sealed class DomainEvent {
  const DomainEvent({
    required this.eventId,
    required this.signerPubkey,
    required this.signature,
    required this.occurredAt,
    this.schemaVersion = 1,
  })  : assert(eventId.length > 0, "eventId darf nicht leer sein"),
        assert(signature.length > 0, "signature darf nicht leer sein (Abschnitt 38: kryptografisch authentifiziert)");

  final EventId eventId;
  final Pubkey signerPubkey;

  /// Opaker Signatur-String; reale Prüfung erfolgt in der
  /// Infrastructure-Schicht mit einer etablierten Krypto-Bibliothek
  /// (Abschnitt 23: „keine eigene Kryptografie").
  final String signature;

  final DateTime occurredAt;
  final int schemaVersion;

  String get eventType;
}

final class ToolCreated extends DomainEvent {
  const ToolCreated({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.toolId,
  });

  final ToolId toolId;

  @override
  String get eventType => "ToolCreated";
}

final class ToolUpdated extends DomainEvent {
  const ToolUpdated({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.toolId,
  });

  final ToolId toolId;

  @override
  String get eventType => "ToolUpdated";
}

final class ToolDeleted extends DomainEvent {
  const ToolDeleted({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.toolId,
  });

  final ToolId toolId;

  @override
  String get eventType => "ToolDeleted";
}

final class LoanRequested extends DomainEvent {
  const LoanRequested({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.requestId,
  });

  final LoanRequestId requestId;

  @override
  String get eventType => "LoanRequested";
}

final class LoanAccepted extends DomainEvent {
  const LoanAccepted({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.loanId,
  });

  final LoanId loanId;

  @override
  String get eventType => "LoanAccepted";
}

final class LoanRejected extends DomainEvent {
  const LoanRejected({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.requestId,
  });

  final LoanRequestId requestId;

  @override
  String get eventType => "LoanRejected";
}

final class LoanCancelled extends DomainEvent {
  const LoanCancelled({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.requestId,
  });

  final LoanRequestId requestId;

  @override
  String get eventType => "LoanCancelled";
}

final class LoanReturned extends DomainEvent {
  const LoanReturned({
    required super.eventId,
    required super.signerPubkey,
    required super.signature,
    required super.occurredAt,
    required this.loanId,
  });

  final LoanId loanId;

  @override
  String get eventType => "LoanReturned";
}
