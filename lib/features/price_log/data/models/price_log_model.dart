import 'package:isar/isar.dart';
import '../../domain/entities/price_log.dart';

part 'price_log_model.g.dart';

@collection
class PriceLogModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid; // entity.id

  late String userId;

  @Index()
  late String productId;

  late String marketId;
  late String? marketName;

  late double price;
  late String currency;
  late DateTime timestamp;

  late bool hasReceipt;
  late String? receiptImageUrl;
  late bool isAvailable;

  // Backend fields
  late String deviceHash;
  late String status; // private | pending | verified
  double? confidenceScore;
  String? abuseFlag;

  // Sync Logic
  @Enumerated(EnumType.ordinal)
  late SyncStatus syncStatus;

  /* ============================
     ENTITY → LOCAL
  ============================ */

  static PriceLogModel fromEntity(PriceLog log) {
    return PriceLogModel()
      ..uuid = log.id
      ..userId = log.userId
      ..productId = log.productId
      ..marketId = log.marketId
      ..marketName = log.marketName
      ..price = log.price
      ..currency = log.currency
      ..timestamp = log.timestamp
      ..hasReceipt = log.hasReceipt
      ..receiptImageUrl = log.receiptImageUrl
      ..isAvailable = log.isAvailable
      ..deviceHash = log.deviceHash
      ..status = log.status
      ..confidenceScore = log.confidenceScore
      ..abuseFlag = log.abuseFlag
      ..syncStatus = _mapSyncStatus(log.syncStatus);
  }

  /* ============================
     LOCAL → ENTITY
  ============================ */

  PriceLog toEntity() {
    return PriceLog(
      id: uuid,
      userId: userId,
      productId: productId,
      marketId: marketId,
      marketName: marketName,
      price: price,
      currency: currency,
      timestamp: timestamp,
      hasReceipt: hasReceipt,
      receiptImageUrl: receiptImageUrl,
      isAvailable: isAvailable,
      deviceHash: deviceHash,
      status: status,
      confidenceScore: confidenceScore,
      abuseFlag: abuseFlag,
      syncStatus: _mapToDomainStatus(syncStatus),
    );
  }

  /* ============================
     STATUS MAPPERS
  ============================ */

  static SyncStatus _mapSyncStatus(PriceLogSyncStatus status) {
    switch (status) {
      case PriceLogSyncStatus.synced:
        return SyncStatus.synced;
      case PriceLogSyncStatus.pending:
        return SyncStatus.pending;
      case PriceLogSyncStatus.failed:
        return SyncStatus.failed;
    }
  }

  static PriceLogSyncStatus _mapToDomainStatus(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return PriceLogSyncStatus.synced;
      case SyncStatus.pending:
        return PriceLogSyncStatus.pending;
      case SyncStatus.failed:
        return PriceLogSyncStatus.failed;
    }
  }
}

enum SyncStatus {
  synced,
  pending,
  failed,
}
