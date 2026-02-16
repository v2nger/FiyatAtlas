import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/device_hash_service.dart';

final deviceHashProvider = FutureProvider<String>((ref) async {
  return DeviceHashService.generate();
});
