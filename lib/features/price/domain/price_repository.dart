import 'price_entry.dart';

abstract class PriceRepository {
  Future<void> addPriceEntry(PriceEntry entry);
  Future<List<PriceEntry>> getRecentEntries({int limit = 20});
  
  // Consensus Methods
  Future<List<PriceEntry>> getConsensusCandidates(String barcode, String marketId);
  Future<void> updateVerifiedPrice({
    required String barcode,
    required String marketId,
    required double price,
    required double confidence,
    required int count,
  });
}
