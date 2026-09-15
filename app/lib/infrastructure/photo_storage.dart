/// Lokale Foto-Ablage (ADR-05, `docs/adr/0005-foto-storage.md`).
///
/// Entscheidung laut ADR-05: Fotos werden komplett lokal gehalten (kein
/// externer Blob-Storage/Blossom-Anbieter). Dateien werden inhaltsadressiert
/// unter ihrem SHA-256-Hash abgelegt – exakt der Wert, den die Domain-Schicht
/// bereits in `Tool.photoRefs` referenziert (siehe `lib/domain/tool.dart`).
///
/// GUARD (offen, siehe README/ARCHITECTURE): Die in ADR-05 zusätzlich
/// beschlossene aktive Verteilung an alle Community-Mitglieder bei
/// Foto-Änderung ist Teil der noch nicht implementierten Nostr-Anbindung
/// (ADR-01/08) und hier bewusst NICHT enthalten – diese Klasse deckt nur die
/// lokale Ablage/den lokalen Abruf ab.
library;

import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:crypto/crypto.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

class PhotoStorage {
  Future<Directory> _photosDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, "photos"));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Speichert [bytes] inhaltsadressiert und gibt den SHA-256-Hex-Hash
  /// zurück (identisch zu einem Eintrag in `Tool.photoRefs`).
  Future<String> save(Uint8List bytes) async {
    final hash = sha256.convert(bytes).toString();
    final dir = await _photosDir();
    final file = File(p.join(dir.path, "$hash.jpg"));
    if (!await file.exists()) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return hash;
  }

  Future<Uint8List?> load(String photoRef) async {
    final dir = await _photosDir();
    final file = File(p.join(dir.path, "$photoRef.jpg"));
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<bool> exists(String photoRef) async {
    final dir = await _photosDir();
    return File(p.join(dir.path, "$photoRef.jpg")).exists();
  }
}

/// Reine Hilfsfunktion (ohne Dateizugriff) – z. B. für Tests, die einen
/// erwarteten Hash unabhängig von [PhotoStorage] berechnen wollen.
String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();

/// Für Debug-/Test-Zwecke: Base64-Kodierung, falls Bilddaten außerhalb der
/// Foto-Ablage transportiert werden müssen.
String encodeBase64(Uint8List bytes) => base64Encode(bytes);
