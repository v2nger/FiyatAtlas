import 'package:fiyatatlas/core/data/in_memory_repository.dart';
import 'package:fiyatatlas/features/price/domain/price_entry.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryRepository repository;

  setUp(() {
    repository = InMemoryRepository();
  });

  group('InMemoryRepository Test', () {
    test('should add and retrieve price entries', () {
      final entry = PriceEntry(
        id: '1',
        barcode: '111',
        marketBranchId: 'branch_A',
        price: 50.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: false,
        status: PriceVerificationStatus.pendingPrivate,
      );

      repository.addEntry(entry);
      
      final entries = repository.getEntries();
      expect(entries.length, greaterThanOrEqualTo(1));
      expect(entries.first.id, '1');
    });

    test('should update existing entry', () {
      final entry = PriceEntry(
        id: '2',
        barcode: '222',
        marketBranchId: 'branch_B',
        price: 100.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: false,
        status: PriceVerificationStatus.pendingPrivate,
      );

      repository.addEntry(entry);

      final updatedEntry = entry.copyWith(status: PriceVerificationStatus.verifiedPublic);
      repository.updateEntry(updatedEntry);

      final entries = repository.getEntries();
      final retrieved = entries.firstWhere((e) => e.id == '2');
      
      expect(retrieved.status, PriceVerificationStatus.verifiedPublic);
    });
  });
}
