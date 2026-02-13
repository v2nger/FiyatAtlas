import 'package:isar/isar.dart';
import '../../../../core/error/exceptions.dart';
import '../models/price_log_model.dart';
import '../../domain/entities/price_log.dart';

abstract class PriceLogLocalDataSource {
  Future<void> cachePriceLog(PriceLog log, {required bool isPending});
  Future<List<PriceLogModel>> getPendingLogs();
  Future<void> markAsSynced(String uuid);
  Future<List<PriceLog>> getLastLogs();
}

class PriceLogLocalDataSourceImpl implements PriceLogLocalDataSource {
  final Isar isar;

  PriceLogLocalDataSourceImpl(this.isar);

  @override
  Future<void> cachePriceLog(PriceLog log, {required bool isPending}) async {
    final entry = PriceLogModel.fromEntity(
      log,
      status: isPending ? SyncStatus.pending : SyncStatus.synced,
    );

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
}
