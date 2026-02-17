import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared_providers.dart';
import '../../../market/data/market_repository_impl.dart';
import '../../../market/domain/market_branch.dart';
import '../../../market/domain/market_repository.dart';

// Repository
final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(ref.watch(firestoreServiceProvider));
});

// State: Current Selected Branch (Check-in)
final currentBranchProvider = StateProvider<MarketBranch?>((ref) => null);

// Data: Fetch all branches (or nearby)
final nearbyBranchesProvider = FutureProvider<List<MarketBranch>>((ref) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getAllBranches(); // Assuming getAllBranches exists
});

// Search Logic for Branches
final branchSearchProvider = FutureProvider.family<List<MarketBranch>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final repo = ref.watch(marketRepositoryProvider);
  // Assuming the repository has a method to search or we filter the 'all branches'
  // For now, let's fetch all and filter in memory if the repo lacks search
  // Or better, implement search in repo.
  // Checking MarketRepository abstract... assuming searchBranches
  final all = await repo.getAllBranches();

  final lowerQuery = query.toLowerCase();
  return all.where((b) {
    return b.displayName.toLowerCase().contains(lowerQuery) ||
        b.city.toLowerCase().contains(lowerQuery) ||
        b.district.toLowerCase().contains(lowerQuery);
  }).toList();
});
