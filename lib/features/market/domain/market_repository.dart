import 'market_branch.dart';

abstract class MarketRepository {
  Future<void> addBranch(MarketBranch branch);
  Future<List<MarketBranch>> getAllBranches();
}
