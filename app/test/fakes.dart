import "package:werkzeugkiste_app/infrastructure/identity_store.dart";

/// Reine In-Memory-Implementierung für Tests – vermeidet Abhängigkeit von
/// `flutter_secure_storage`-Plattform-Channels, die in `flutter test` ohne
/// echtes Gerät nicht verfügbar sind.
class FakeIdentityStore implements IdentityStore {
  DeviceIdentity? _identity;

  @override
  Future<DeviceIdentity?> loadExisting() async => _identity;

  @override
  Future<DeviceIdentity> createIdentity(String displayName) async {
    _identity = DeviceIdentity(pubkey: "test-pubkey-${identityCounter++}", displayName: displayName);
    return _identity!;
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final current = _identity;
    if (current != null) {
      _identity = DeviceIdentity(pubkey: current.pubkey, displayName: displayName);
    }
  }

  static int identityCounter = 0;
}
