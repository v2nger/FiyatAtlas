import 'price_status.dart';

class PriceEntry {
  PriceEntry({
    required this.id,
    this.userId,
    required this.barcode,
    required this.marketBranchId,
    required this.price,
    required this.currency,
    required this.entryDate,
    required this.hasReceipt,
    this.receiptImageUrl,
    this.isAvailable = true,
    required this.status,
  });

  final String id;
  /// The ID of the user who created this entry. 
  /// Nullable for backward compatibility or anonymous entries.
  final String? userId; 
  final String barcode;
  final String marketBranchId;
  final double price;
  final String currency;
  final DateTime entryDate;
  final bool hasReceipt;
  final String? receiptImageUrl;
  final bool isAvailable;
  final PriceVerificationStatus status;

  PriceEntry copyWith({
    String? id,
    String? userId,
    String? barcode,
    String? marketBranchId,
    double? price,
    String? currency,
    DateTime? entryDate,
    bool? hasReceipt,
    String? receiptImageUrl,
    bool? isAvailable,
    PriceVerificationStatus? status,
  }) {
    return PriceEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      barcode: barcode ?? this.barcode,
      marketBranchId: marketBranchId ?? this.marketBranchId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      entryDate: entryDate ?? this.entryDate,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      status: status ?? this.status,
    );
  }
}
