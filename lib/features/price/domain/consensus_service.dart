import '../domain/price_entry.dart';

class ConsensusResult {
  final double price;
  final double confidenceScore;
  final int confirmationCount;
  final bool isVerified;

  ConsensusResult({
    required this.price,
    required this.confidenceScore,
    required this.confirmationCount,
    this.isVerified = false,
  });
}

/// DEPRECATED: Verification logic has moved to Backend (Cloud Functions).
/// This service is kept temporarily to prevent compilation errors in legacy code.
class ConsensusService {
  ConsensusResult? evaluate(List<PriceEntry> entries) {
    // Logic moved to backend.
    // Return null to ensure client doesn't attempt to write to verified collection.
    return null;
  }
}
