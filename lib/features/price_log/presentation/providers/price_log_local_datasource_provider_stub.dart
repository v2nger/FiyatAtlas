import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/price_log_local_datasource.dart';
import '../../domain/entities/price_log.dart';

class WebPriceLogLocalDataSource implements PriceLogLocalDataSource {
  @override
  Future<void> cachePriceLog(PriceLog log, {required bool isPending}) async {
    // No-op
  }

  @override
  Future<List<PriceLog>> getLastLogs() async => [];

  @override
  Future<List<PriceLog>> getLogsByProduct(String barcode) async => [];

  @override
  Future<List<PriceLog>> getPendingLogs() async => [];

  @override
  Future<void> markAsSynced(String uuid) async {
    // No-op
  }
}

final priceLogDataSourceProvider = Provider<PriceLogLocalDataSource>((ref) {
  return WebPriceLogLocalDataSource();
});
