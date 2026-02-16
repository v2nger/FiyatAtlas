// The mobile implementation.
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/price_log/data/models/price_log_model.dart';
// Note: We need to import the Isar model file here to register schema
// If this file is only imported conditionally, it won't be compiled on web.

Future<Isar?> initIsar() async {
  if (kIsWeb) return null; // Should not happen with conditional imports, but safe.

  final dir = await getApplicationDocumentsDirectory();
  final path = dir.path;
  debugPrint('Isar Path (Mobile): $path');

  final isar = await Isar.open(
    [PriceLogIsarEntrySchema],
    directory: path,
  );
  return isar;
}
