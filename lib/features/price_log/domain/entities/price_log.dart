import 'package:equatable/equatable.dart';

class PriceLog extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final String marketId;
  final String? marketName;
  final double price;
  final String currency;
  final DateTime timestamp;

  final bool hasReceipt;
  final String? receiptImageUrl;
  final String? receiptRawText;

  final bool isAvailable;
  final String deviceHash;

  final PriceLogSyncStatus syncStatus;

  const PriceLog({
    required this.id,
    required this.userId,
    required this.productId,
    required this.marketId,
    this.marketName,
    required this.price,
    this.currency = 'TRY',
    required this.timestamp,
    required this.hasReceipt,
    this.receiptImageUrl,
    this.receiptRawText,
    this.isAvailable = true,
    required this.deviceHash,
    this.syncStatus = PriceLogSyncStatus.pending,
  });

  PriceLog copyWith({
    String? id,
    String? userId,
    String? productId,
    String? marketId,
    String? marketName,
    double? price,
    String? currency,
    DateTime? timestamp,
    bool? hasReceipt,
    String? receiptImageUrl,
    String? receiptRawText,
    bool? isAvailable,
    String? deviceHash,
    PriceLogSyncStatus? syncStatus,
  }) {
    return PriceLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      marketId: marketId ?? this.marketId,
      marketName: marketName ?? this.marketName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      receiptRawText: receiptRawText ?? this.receiptRawText,
      isAvailable: isAvailable ?? this.isAvailable,
      deviceHash: deviceHash ?? this.deviceHash,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        marketId,
        marketName,
        price,
        currency,
        timestamp,
        hasReceipt,
        receiptImageUrl,
        receiptRawText,
        isAvailable,
        deviceHash,
        syncStatus,
      ];
}

enum PriceLogSyncStatus {
  synced,
  pending,
  failed,
}
