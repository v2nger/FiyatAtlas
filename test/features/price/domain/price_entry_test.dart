import 'package:fiyatatlas/features/price/domain/price_entry.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceEntry Domain Test', () {
    test('supports value comparison via copyWith', () {
      final entry = PriceEntry(
        id: '1',
        barcode: '123456',
        marketBranchId: 'branch1',
        price: 10.0,
        currency: 'TRY',
        entryDate: DateTime(2023, 1, 1),
        hasReceipt: false,
        status: PriceVerificationStatus.pendingPrivate,
      );

      final entry2 = entry.copyWith(price: 20.0);

      expect(entry.price, 10.0);
      expect(entry2.price, 20.0);
      expect(entry.id, entry2.id); // ID should remain same
    });

    test('initial status is correct', () {
      final entry = PriceEntry(
        id: '2',
        barcode: '123456',
        marketBranchId: 'branch1',
        price: 15.0,
        currency: 'TRY',
        entryDate: DateTime.now(),
        hasReceipt: true,
        status: PriceVerificationStatus.awaitingConsensus,
      );

      expect(entry.status, PriceVerificationStatus.awaitingConsensus);
      expect(entry.hasReceipt, true);
    });
  });
}
