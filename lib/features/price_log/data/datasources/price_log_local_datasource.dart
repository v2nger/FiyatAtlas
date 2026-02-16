import '../../domain/entities/price_log.dart';

abstract class PriceLogLocalDataSource {
  Future<void> cachePriceLog(PriceLog log, {required bool isPending});
  Future<List<PriceLog>> getPendingLogs();
  Future<void> markAsSynced(String uuid);
  Future<List<PriceLog>> getLastLogs();
  Future<List<PriceLog>> getLogsByProduct(String barcode);
}
