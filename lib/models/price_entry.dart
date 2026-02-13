import 'price_status.dart';

class PriceEntry {
  PriceEntry({
    required this.id,
    required this.barcode,
    required this.marketBranchId,
    required this.price,
    required this.currency,
    required this.entryDate,
    required this.hasReceipt,
    this.isAvailable = true,
    required this.status,
  });

  final String id;
  final String barcode;
  final String marketBranchId;
  final double price;
  final String currency;
  final DateTime entryDate;
  final bool hasReceipt;
  final bool isAvailable;
  final PriceVerificationStatus status;
}
