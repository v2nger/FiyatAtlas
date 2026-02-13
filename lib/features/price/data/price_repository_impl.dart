import '../../../core/services/firestore_service.dart';
import '../../price/domain/price_entry.dart';
import 'price_repository.dart';

class PriceRepositoryImpl implements PriceRepository {
  final FirestoreService _firestoreService;

  PriceRepositoryImpl(this._firestoreService);

  @override
  Future<void> addPriceEntry(PriceEntry entry) async {
    await _firestoreService.logPriceEntry(entry);
  }

  @override
  Future<List<PriceEntry>> getRecentEntries({int limit = 20}) async {
    return _firestoreService.getRecentPriceLogs(limit: limit);
  }

  @override
  Future<List<PriceEntry>> getConsensusCandidates(String barcode, String marketId) async {
    // Look back 48 hours for consensus
    final since = DateTime.now().subtract(const Duration(hours: 48));
    return _firestoreService.getLogHistoryForConsensus(barcode, marketId, since);
  }

  @override
  Future<void> updateVerifiedPrice({
    required String barcode,
    required String marketId,
    required double price,
    required double confidence,
    required int count,
  }) async {
    await _firestoreService.updateVerifiedPrice(
      barcode: barcode,
      marketId: marketId,
      price: price,
      confidenceScore: confidence,
      confirmationCount: count,
    );
  }
}
