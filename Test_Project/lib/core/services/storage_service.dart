import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  /// =========================
  /// SAVE DATA
  /// =========================

  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// =========================
  /// READ DATA
  /// =========================

  static dynamic read(String key) {
    return _box.read(key);
  }

  /// =========================
  /// REMOVE DATA
  /// =========================

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// =========================
  /// CLEAR STORAGE
  /// =========================

  static Future<void> clear() async {
    await _box.erase();
  }

  /// =========================
  /// CHECK IF KEY EXISTS
  /// =========================

  static bool hasKey(String key) {
    return _box.hasData(key);
  }
}
