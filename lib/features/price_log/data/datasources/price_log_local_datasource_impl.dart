import 'package:isar/isar.dart';

import '../../domain/entities/price_log.dart';
import '../models/price_log_model.dart';
import 'price_log_local_datasource.dart';

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

    final entry = PriceLogIsarEntry.fromEntity(entityToSave);

    await isar.writeTxn(() async {
      await isar.priceLogIsarEntrys.put(entry);
    });
  }

  @override
  Future<List<PriceLog>> getPendingLogs() async {
    final entrys = await isar.priceLogIsarEntrys
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    return entrys.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> markAsSynced(String uuid) async {
    await isar.writeTxn(() async {
      final entry = await isar.priceLogIsarEntrys.filter().uuidEqualTo(uuid).findFirst();
      if (entry != null) {
        entry.syncStatus = SyncStatus.synced;
        await isar.priceLogIsarEntrys.put(entry);
      }
    });
  }

  @override
  Future<List<PriceLog>> getLastLogs() async {
    final models = await isar.priceLogIsarEntrys
        .where()
        .sortByTimestampDesc()
        .limit(20)
        .findAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<PriceLog>> getLogsByProduct(String barcode) async {
    final models = await isar.priceLogIsarEntrys
        .filter()
        .productIdEqualTo(barcode)
        .findAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
