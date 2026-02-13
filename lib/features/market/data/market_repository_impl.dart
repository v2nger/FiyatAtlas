import '../../../core/services/firestore_service.dart';
import '../../market/domain/market_branch.dart';
import '../domain/market_repository.dart';

class MarketRepositoryImpl implements MarketRepository {
  final FirestoreService _firestoreService;

  MarketRepositoryImpl(this._firestoreService);

  @override
  Future<void> addBranch(MarketBranch branch) async {
    await _firestoreService.addMarketBranch(branch);
  }

  @override
  Future<List<MarketBranch>> getAllBranches() async {
    return _firestoreService.getMarketBranches();
  }
}
