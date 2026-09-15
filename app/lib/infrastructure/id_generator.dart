/// Erzeugung neuer Entitäts-IDs (ToolId, LoanRequestId, ...) sowie von
/// Einladungs-Tokens (ADR-03).
library;

import "dart:convert";
import "dart:math";

import "package:crypto/crypto.dart";
import "package:uuid/uuid.dart";

class IdGenerator {
  const IdGenerator();

  static const _uuid = Uuid();

  String newId() => _uuid.v4();

  /// Erzeugt ein zufälliges Einladungs-Token (Klartext, wird außerhalb der
  /// Domain-Schicht gehasht, siehe `lib/domain/invite_service.dart`:
  /// `createInvite`/`consumeInvite` arbeiten bewusst nur mit bereits
  /// berechneten Hash-Werten, Abschnitt 23 "keine eigene Kryptografie in der
  /// Domain-Schicht").
  String newInviteToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(24, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll("=", "");
  }

  String hashToken(String token) => sha256.convert(utf8.encode(token)).toString();
}
