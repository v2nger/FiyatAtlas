import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceHashService {
  static Future<String> generate() async {
    final deviceInfo = DeviceInfoPlugin();

    String raw = "";

    if (kIsWeb) {
      raw = "web_${DateTime.now().millisecondsSinceEpoch}";
    } else {
      final info = await deviceInfo.deviceInfo;
      raw = info.data.toString();
    }

    final bytes = utf8.encode(raw);
    final hash = sha256.convert(bytes);

    return hash.toString();
  }
}
