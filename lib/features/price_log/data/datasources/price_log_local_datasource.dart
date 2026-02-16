import 'package:isar/isar.dart';

import '../../domain/entities/price_log.dart';
import '../models/price_log_model.dart';

abstract class PriceLogLocalDataSource {
  Future<void> cachePriceLog(PriceLog log, {required bool isPending});
  Future<List<PriceLogModel>> getPendingLogs();
  Future<void> markAsSynced(String uuid);
  Future<List<PriceLog>> getLastLogs();
  Future<List<PriceLog>> getLogsByProduct(String barcode);
}

class PriceLogLocalDataSourceImpl implements PriceLogLocalDataSource {
  final Isar isar;

  PriceLogLocalDataSourceImpl(this.isar);

  @override
  Future<void> cachePriceLog(PriceLog log, {required bool isPending}) async {
    // Override sync status in the entity for storage logic
    final statusToSave = isPending
        ? PriceLogSyncStatus.pending
        : PriceLogSyncStatus.synced;
    
    // Create new copy with correct status to map
    final entityToSave = log.copyWith(syncStatus: statusToSave);

    final entry = PriceLogModel.fromEntity(entityToSave);

    await isar.writeTxn(() async {
      await isar.priceLogModels.put(entry);
    });
  }

  @override
  Future<List<PriceLogModel>> getPendingLogs() async {
    return await isar.priceLogModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  @override
  Future<void> markAsSynced(String uuid) async {
    await isar.writeTxn(() async {
      final entry = await isar.priceLogModels.filter().uuidEqualTo(uuid).findFirst();
      if (entry != null) {
        entry.syncStatus = SyncStatus.synced;
        await isar.priceLogModels.put(entry);
      }
    });
  }

  @override
  Future<List<PriceLog>> getLastLogs() async {
    final models = await isar.priceLogModels.where().sortByTimestampDesc().limit(20).findAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<PriceLog>> getLogsByProduct(String barcode) async {
    final models = await isar.priceLogModels.filter().productIdEqualTo(barcode).findAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
