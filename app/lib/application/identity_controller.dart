/// Lädt/erzeugt die lokale Geräte-Identität (siehe
/// `lib/infrastructure/identity_store.dart` für die wichtige Abgrenzung:
/// Platzhalter-Pubkey, kein echtes Nostr-Schlüsselpaar).
library;

import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";

import "../infrastructure/identity_store.dart";
import "database_providers.dart";

class IdentityController extends AsyncNotifier<DeviceIdentity?> {
  @override
  FutureOr<DeviceIdentity?> build() {
    return ref.watch(identityStoreProvider).loadExisting();
  }

  Future<void> createIdentity(String displayName) async {
    final store = ref.read(identityStoreProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => store.createIdentity(displayName));
  }

  Future<void> updateDisplayName(String displayName) async {
    final store = ref.read(identityStoreProvider);
    await store.updateDisplayName(displayName);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(DeviceIdentity(pubkey: current.pubkey, displayName: displayName));
    }
  }
}

final identityControllerProvider = AsyncNotifierProvider<IdentityController, DeviceIdentity?>(
  IdentityController.new,
);
