import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/shared_providers.dart';
import '../models/price_log_model.dart';
import 'price_log_local_datasource_impl.dart';

/// Initializes Isar and overrides the provider for Mobile only.
/// This function should NEVER be called on Web.
Future<void> initializeIsarForMobile(ProviderContainer container) async {
  if (kIsWeb) return;

  final dir = await getApplicationDocumentsDirectory();
  final path = dir.path;
  debugPrint('Isar Path by Helper: $path');

  final isar = await Isar.open(
    [PriceLogIsarEntrySchema],
    directory: path,
  );

  // We can't easily override the container here since it's already built?
  // Actually, we pass the container, but overriding after build?
  // Allowed for `ProviderContainer` but maybe not best practice.
  // Better: Return the Isar instance and let main override it?
  // But we want to isolate the Schema import.
}

/// Returns the Isar instance directly.
Future<Isar> getIsarInstance() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [PriceLogIsarEntrySchema],
    directory: dir.path,
  );
}
