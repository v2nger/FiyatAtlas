import 'package:fiyatatlas/core/data/in_memory_repository.dart';
import 'package:fiyatatlas/features/price/domain/price_entry.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';
import 'package:fiyatatlas/features/verification/data/verification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryRepository repository;
  late VerificationService service;

  setUp(() {
    repository = InMemoryRepository();
    service = VerificationService(repository);
  });

  group('Confidence Engine Test (VerificationService)', () {
    test('Basic entry without receipt should likely be Pending (Score < 60)', () async {
      // Base (40) + Unique User (1 * 15) = 55 -> Pending Private
      // UserID null -> 0 bonus trusted? Let's check logic.
      // Logic: 
      // Base = 40
      // Unique users excluding self. Map includes self if related found. 
      // If none related, unique = 0? Or 1 (self)? 
      // The code logic: `relatedEntries = entries.where ... id != entry.id`
      // If list empty, uniqueUserCount = 0.
      // Score = 40 + 0 = 40.
      // < 60 -> pendingPrivate.
      
      final entry = PriceEntry(
        id: 'test_1',
        userId: 'user_1',
        barcode: '8690001',
        marketBranchId: 'market_1',
        price: 10.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: false,
        status: PriceVerificationStatus.pendingPrivate,
      );
      
      repository.addEntry(entry);

      await service.trustCheck('test_1');

      final updated = repository.getEntries().firstWhere((e) => e.id == 'test_1');
      expect(updated.status, PriceVerificationStatus.pendingPrivate); 
      // 40 < 60
    });

    test('Entry with receipt should get bonus', () async {
      // Base (40) + Receipt (25) = 65.
      // 60 <= 65 < 80 -> awaitingConsensus.
      
      final entry = PriceEntry(
        id: 'test_2',
        userId: 'user_2',
        barcode: '8690002',
        marketBranchId: 'market_2',
        price: 20.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: true, // Bonus +25
        status: PriceVerificationStatus.pendingPrivate,
      );

      repository.addEntry(entry);
      await service.trustCheck('test_2');

      final updated = repository.getEntries().firstWhere((e) => e.id == 'test_2');
      expect(updated.status, PriceVerificationStatus.awaitingConsensus);
    });

    test('Entry with receipt AND trusted user AND peers should verify', () async {
      // Setup: 
      // 1. Existing entry from another user (to boost unique user count)
      // 2. New entry with receipt (+25) + trusted bonus (+10) + Image (+15).
      
      // Existing entry
      repository.addEntry(PriceEntry(
        id: 'other_1',
        userId: 'peer_user',
        barcode: '8690003',
        marketBranchId: 'market_3',
        price: 100.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: false,
        status: PriceVerificationStatus.pendingPrivate,
      ));

      // Target Entry
      // Base: 40
      // Unique Users (Other user): +15 (1 * 15)
      // Receipt: +25
      // Receipt Image: +15
      // Trusted User (Hash even): +10 "user_trusted" -> hash code even check required or mock.
      // Total: 40 + 15 + 25 + 15 + (10 maybe) = 105. > 80.
      
      final entry = PriceEntry(
        id: 'test_3',
        userId: 'user_trusted', // Will assume even hash or close enough for high score
        barcode: '8690003',
        marketBranchId: 'market_3',
        price: 100.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: true,
        receiptImageUrl: 'http://img.url',
        status: PriceVerificationStatus.pendingPrivate,
      );

      repository.addEntry(entry);
      await service.trustCheck('test_3');

      final updated = repository.getEntries().firstWhere((e) => e.id == 'test_3');
      expect(updated.status, PriceVerificationStatus.verifiedPublic);
    });

    test('Anomaly penalty should reduce score', () async {
      // 3 existing entries with price ~10.0
      // New entry with price 100.0 (Huge difference)
      
      // Base: 40
      // Unique users: 1 * 15 = 15
      // Receipt: 0
      // Anomaly: 100 vs 10 = 900% diff -> -50 penalty.
      // Total: 55 - 50 = 5. -> Pending Private. (Even with receipts it would struggle).

      repository.addEntry(PriceEntry(
        id: 'existing_1',
        userId: 'peer_1',
        barcode: '8690004',
        marketBranchId: 'market_4',
        price: 10.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: false,
        status: PriceVerificationStatus.verifiedPublic,
      ));

      final anomalyEntry = PriceEntry(
        id: 'anomaly_1',
        userId: 'user_anomaly',
        barcode: '8690004',
        marketBranchId: 'market_4',
        price: 100.0, // 10x price
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: true, // +25 bonus
        status: PriceVerificationStatus.pendingPrivate,
      );
      // Base 40 + Receipt 25 + Unique 15 = 80.
      // Penalty: -50.
      // Final: 30.

      repository.addEntry(anomalyEntry);
      await service.trustCheck('anomaly_1');

      final updated = repository.getEntries().firstWhere((e) => e.id == 'anomaly_1');
      expect(updated.status, PriceVerificationStatus.pendingPrivate);
    });
  });
}
