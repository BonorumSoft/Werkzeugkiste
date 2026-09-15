/// Lokale Geräte-Identität (ADR-06, `docs/adr/0006-backup-recovery.md`).
///
/// WICHTIG – ehrliche Abgrenzung (siehe README/ARCHITECTURE):
/// Diese Klasse erzeugt und verwaltet aktuell einen LOKAL zufällig
/// generierten Platzhalter-Pubkey (32 zufällige Bytes, hex-kodiert). Das ist
/// AUSDRÜCKLICH KEIN echtes secp256k1-Schlüsselpaar und KEIN Nostr-Schlüssel
/// (nsec/npub) – die eigentliche kryptografische Identität ist Teil der noch
/// nicht implementierten Nostr-Anbindung (ADR-01, ADR-06 "ein Schlüsselpaar
/// PRO GERÄT"). Diese Klasse liefert lediglich ein stabiles, gerätelokales
/// `Pubkey`-Äquivalent (siehe `package:werkzeugkiste/domain/ids.dart`),
/// damit die Domain-Operationen (die einen Aktor-Pubkey erwarten) schon
/// heute sinnvoll ausgeführt werden können.
///
/// Ablage über `flutter_secure_storage` (iOS Keychain / Android Keystore) –
/// das ist bereits die in ADR-06/07 vorgesehene Ablageform, nur eben aktuell
/// mit Platzhalter-Inhalt statt echtem Schlüsselmaterial.
library;

import "dart:math";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:werkzeugkiste/domain/ids.dart";

class DeviceIdentity {
  const DeviceIdentity({required this.pubkey, required this.displayName});

  final Pubkey pubkey;
  final String displayName;
}

class IdentityStore {
  IdentityStore({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _pubkeyKey = "device_pubkey_placeholder";
  static const _displayNameKey = "device_display_name";

  Future<DeviceIdentity?> loadExisting() async {
    final pubkey = await _storage.read(key: _pubkeyKey);
    final displayName = await _storage.read(key: _displayNameKey);
    if (pubkey == null || displayName == null) return null;
    return DeviceIdentity(pubkey: pubkey, displayName: displayName);
  }

  Future<DeviceIdentity> createIdentity(String displayName) async {
    final pubkey = _generatePlaceholderPubkey();
    await _storage.write(key: _pubkeyKey, value: pubkey);
    await _storage.write(key: _displayNameKey, value: displayName);
    return DeviceIdentity(pubkey: pubkey, displayName: displayName);
  }

  Future<void> updateDisplayName(String displayName) async {
    await _storage.write(key: _displayNameKey, value: displayName);
  }

  static String _generatePlaceholderPubkey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, "0")).join();
  }
}
