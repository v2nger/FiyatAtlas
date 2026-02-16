import 'package:fiyatatlas/features/auth/domain/user.dart';
import 'package:fiyatatlas/features/gamification/domain/gamification_service.dart';
import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/product/domain/entities/product.dart';

import '../consensus_service.dart';
import '../price_entry.dart';
import '../price_repository.dart';
import '../price_status.dart';

class LogPriceUseCase {
  final PriceRepository _priceRepository;
  final GamificationService _gamificationService;
  final ConsensusService _consensusService;

  LogPriceUseCase(
    this._priceRepository, 
    this._gamificationService,
    this._consensusService,
  );

  Future<User?> execute({
    required User currentUser,
    required String barcode,
    required String marketBranchId,
    required double price,
    required bool hasReceipt,
    required bool isAvailable,
    required List<Product> allProducts,
    required List<MarketBranch> allBranches,
    required List<PriceEntry> userPastEntries,
  }) async {
    // 1. Create Entry 
    final entry = PriceEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.id,
      barcode: barcode,
      marketBranchId: marketBranchId,
      price: price,
      currency: 'TRY',
      entryDate: DateTime.now(),
      hasReceipt: hasReceipt,
      isAvailable: isAvailable,
      status: hasReceipt
          ? PriceVerificationStatus.awaitingConsensus
          : PriceVerificationStatus.pendingPrivate,
    );

    // 2. Persist to Log (Append-Only)
    await _priceRepository.addPriceEntry(entry);

    // 3. Trigger Consensus Engine
    // Fetch all candidates (last 48h)
    final candidates = await _priceRepository.getConsensusCandidates(barcode, marketBranchId);
    
    // Evaluate
    final result = _consensusService.evaluate(candidates);

    if (result != null && result.isVerified) {
       // 4. Update Public Dataset (Verified Collection)
       await _priceRepository.updateVerifiedPrice(
         barcode: barcode, 
         marketId: marketBranchId, 
         price: result.price,
         confidence: result.confidenceScore,
         count: result.confirmationCount,
       );
    } else {
      // Logic for "Single User Pending" update?
      // In a strict P2P system, we might NOT show this to public yet.
      // Or we show it with "Unverified" badge. 
      // For this implementation, we only write to verified verified_prices 
      // if logic allows, OR if we want to show unverified data, we might write it 
      // but mark status as pending.
      // Let's adopt a "Show Latest Unverified" approach for MVP but mark it clearly,
      // OR strictly hide until verifiable.
      // User request: "Gerçek 2+ bağımsız kullanıcı eşleştirme... Public dataset ayrımı"
      // This implies we should ONLY write to VerifiedPublic if result.isVerified is true.
      // But for UX, users want to see their own price. 
      // Answer: User sees their own price via Local State / Logs. Public sees Verified.
    }

    // 5. Game Mechanics
    // Points rule: +10 points per entry
    int pointsEarned = 10;
    
    // Check Badges
    final newBadges = _gamificationService.checkBadges(
      user: currentUser,
      newEntry: entry,
      allProducts: allProducts,
      allBranches: allBranches,
      userPastEntries: userPastEntries,
    );

    // Bonus points for badges (50 per badge)
    pointsEarned += (newBadges.length * 50);
    
    // Bonus for Consensus: If this entry triggered a verification
    if (result != null && result.isVerified && result.confirmationCount == 2) {
       // This user was the 2nd one to confirm! Big bonus.
       pointsEarned += 20;
    }

    // 6. Return Updated User
    return User(
      id: currentUser.id,
      name: currentUser.name,
      email: currentUser.email,
      avatarUrl: currentUser.avatarUrl,
      points: currentUser.points + pointsEarned,
      entryCount: currentUser.entryCount + 1,
      rank: currentUser.rank,
      joinDate: currentUser.joinDate,
      earnedBadgeIds: [...currentUser.earnedBadgeIds, ...newBadges],
    );
  }
}
