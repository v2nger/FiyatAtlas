import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared_providers.dart';
import '../../data/datasources/price_log_local_datasource.dart';
import '../../data/datasources/price_log_local_datasource_impl.dart';
// It is safe to import Isar related file here, as this file is only used on Mobile

final priceLogDataSourceProvider = Provider<PriceLogLocalDataSource>((ref) {
  return PriceLogLocalDataSourceImpl(ref.watch(isarProvider));
});
