import 'package:equatable/equatable.dart';

class VerifiedPrice extends Equatable {
  final String barcode;
  final String marketId;
  final double price;
  final double confidenceScore; // 0.0 to 1.0
  final int confirmationCount;
  final DateTime lastVerifiedAt;

  const VerifiedPrice({
    required this.barcode,
    required this.marketId,
    required this.price,
    required this.confidenceScore,
    required this.confirmationCount,
    required this.lastVerifiedAt,
  });

  @override
  List<Object?> get props => [barcode, marketId, price, confidenceScore, confirmationCount, lastVerifiedAt];
}
