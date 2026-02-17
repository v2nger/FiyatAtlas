import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================= DEVICE HASH SERVICE =================
/// Backend device_abuseEngine için gerekli
class DeviceHashService {
  static Future<String> generate() async {
    final deviceInfo = DeviceInfoPlugin();
    String raw;

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

/// ================= MARKET SESSION PROVIDER =================
/// Kullanıcı X marketteyim → session tutar

final activeMarketProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => null,
);

void enterMarket(
  WidgetRef ref, {
  required String marketId,
  required String marketName,
}) {
  ref.read(activeMarketProvider.notifier).state = {
    "market_id": marketId,
    "market_name": marketName,
    "entered_at": DateTime.now(),
  };
}

void exitMarket(WidgetRef ref) {
  ref.read(activeMarketProvider.notifier).state = null;
}
