// Abstract class for PriceLogLocalDataSource
import '../../domain/entities/price_log.dart';

abstract class PriceLogLocalDataSource {
  Future<void> cachePriceLog(PriceLog log, {required bool isPending});
  Future<List<PriceLog>> getPendingLogsEntity(); // Updated to return entity not model
  Future<void> markAsSynced(String uuid);
  Future<List<PriceLog>> getLastLogs();
  Future<List<PriceLog>> getLogsByProduct(String barcode);
}
