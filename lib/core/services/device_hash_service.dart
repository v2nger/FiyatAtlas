import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceHashService {
  static Future<String> generate() async {
    final deviceInfo = DeviceInfoPlugin();
    String raw;

    final info = await deviceInfo.deviceInfo;
    raw = info.data.toString();

    return sha256.convert(utf8.encode(raw)).toString();
  }
}
