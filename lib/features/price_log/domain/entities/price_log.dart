import 'package:equatable/equatable.dart';

class PriceLog extends Equatable {
  final String id;
  final String userId;
  final String productId; // Barcode
  final String marketId;
  final double price;
  final String currency;
  final DateTime timestamp;
  final bool hasReceipt;
  final String? receiptImageUrl;
  final bool isAvailable;

  const PriceLog({
    required this.id,
    required this.userId,
    required this.productId,
    required this.marketId,
    required this.price,
    this.currency = 'TRY',
    required this.timestamp,
    required this.hasReceipt,
    this.receiptImageUrl,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        marketId,
        price,
        currency,
        timestamp,
        hasReceipt,
        receiptImageUrl,
        isAvailable,
      ];
}
