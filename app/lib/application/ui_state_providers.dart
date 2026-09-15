/// Rein UI-lokaler (nicht persistenter) Zustand.
library;

import "package:flutter_riverpod/flutter_riverpod.dart";

/// Die aktuell im UI ausgewählte Community. `null` bedeutet: noch keine
/// Auswahl getroffen (Community-Auswahl-/Erstellungs-Bildschirm wird
/// gezeigt).
final selectedCommunityIdProvider = StateProvider<String?>((ref) => null);
