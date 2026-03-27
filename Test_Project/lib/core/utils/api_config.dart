import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    /// 🌐 WEB
    if (kIsWeb) {
      return "https://civilengg-production.up.railway.app";
    }

    /// 🤖 ANDROID EMULATOR
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    }

    /// 🍎 IOS / DESKTOP
    if (!kIsWeb &&
        (Platform.isIOS ||
            Platform.isMacOS ||
            Platform.isWindows ||
            Platform.isLinux)) {
      return "https://civilengg-production.up.railway.app";
    }

    /// 📱 REAL DEVICE (CHANGE THIS)
    return "http://192.168.1.10:3000"; // 🔥 PUT YOUR PC IP HERE
  }
}
