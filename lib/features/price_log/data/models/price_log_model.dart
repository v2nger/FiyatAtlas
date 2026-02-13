import 'package:isar/isar.dart';
import '../../domain/entities/price_log.dart';

part 'price_log_model.g.dart';

@collection
class PriceLogModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid; // mapped from entity.id

  late String userId;
  
  @Index()
  late String productId;
  
  late String marketId;
  late double price;
  late String currency;
  late DateTime timestamp;
  late bool hasReceipt;
  late String? receiptImageUrl;
  late bool isAvailable;

  // Sync Logic
  @Enumerated(EnumType.ordinal)
  late SyncStatus syncStatus;

  /// Converts API/Domain log to Local Model
  static PriceLogModel fromEntity(PriceLog log, {SyncStatus status = SyncStatus.synced}) {
    return PriceLogModel()
      ..uuid = log.id
      ..userId = log.userId
      ..productId = log.productId
      ..marketId = log.marketId
      ..price = log.price
      ..currency = log.currency
      ..timestamp = log.timestamp
      ..hasReceipt = log.hasReceipt
      ..receiptImageUrl = log.receiptImageUrl
      ..isAvailable = log.isAvailable
      ..syncStatus = status;
  }

  /// Converts Local Model to Domain Entity
  PriceLog toEntity() {
    return PriceLog(
      id: uuid,
      userId: userId,
      productId: productId,
      marketId: marketId,
      price: price,
      currency: currency,
      timestamp: timestamp,
      hasReceipt: hasReceipt,
      receiptImageUrl: receiptImageUrl,
      isAvailable: isAvailable,
    );
  }
}

enum SyncStatus {
  synced,
  pending,
  failed,
}
