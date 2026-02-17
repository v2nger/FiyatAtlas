import 'package:cloud_firestore/cloud_firestore.dart';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': barcode,
      'market_id': marketBranchId,
      'price': price,
      'currency': currency,
      'timestamp': Timestamp.fromDate(entryDate),
      'hasReceipt': hasReceipt,
      'receipt_url': receiptImageUrl,
      'isAvailable': isAvailable,
      'status': status.name, // Enum to string
    };
  }

  factory PriceEntry.fromMap(Map<String, dynamic> map) {
    return PriceEntry(
      id: map['id'] ?? map['uuid'] ?? '',
      userId: map['userId'] ?? map['user_id'],
      barcode: map['barcode'] ?? map['product_id'] ?? '',
      marketBranchId: map['marketBranchId'] ?? map['market_id'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'TRY',
      entryDate: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : (map['entryDate'] != null
                ? DateTime.parse(map['entryDate'])
                : DateTime.now()),
      hasReceipt: map['hasReceipt'] ?? (map['receipt_url'] != null),
      receiptImageUrl: map['receiptImageUrl'] ?? map['receipt_url'],
      isAvailable: map['isAvailable'] ?? true,
      status: map['status'] != null
          ? (PriceVerificationStatus.values.asNameMap()[map['status']] ??
                PriceVerificationStatus.pendingPrivate)
          : PriceVerificationStatus.pendingPrivate,
    );
  }

  // Legacy accessor for timestamp (if used elsewhere)
  DateTime get timestamp => entryDate;
}
