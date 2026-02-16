import 'package:dartz/dartz.dart';
import 'package:fiyatatlas/features/price_log/domain/entities/price_log.dart';
import 'package:fiyatatlas/features/price_log/domain/repositories/price_log_repository.dart';
import 'package:fiyatatlas/features/price_log/domain/usecases/submit_price_log_usecase.dart';
import 'package:fiyatatlas/features/product/domain/entities/product.dart';
import 'package:fiyatatlas/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'submit_price_log_test.mocks.dart';

@GenerateMocks([PriceLogRepository, ProductRepository])
void main() {
  late SubmitPriceLog useCase;
  late MockPriceLogRepository mockRepository;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockRepository = MockPriceLogRepository();
    mockProductRepository = MockProductRepository();
    useCase = SubmitPriceLog(
      priceLogRepository: mockRepository,
      productRepository: mockProductRepository,
    );
  });

  final tPriceLog = PriceLog(
    id: '1',
    userId: 'user1',
    productId: '123456',
    marketId: 'market1',
    price: 10.5,
    timestamp: DateTime.now(),
    hasReceipt: true,
    deviceHash: 'test_hash',
  );

  test('should call submitPriceLog from repository', () async {
    // arrange
    when(mockRepository.submitPriceLog(tPriceLog))
        .thenAnswer((_) async => const Right(null));

    when(mockProductRepository.createIfNotExists(
      barcode: anyNamed('barcode'),
      name: anyNamed('name'),
      brand: anyNamed('brand'),
    )).thenAnswer((_) async => Product(
          barcode: tPriceLog.productId,
          name: 'Test Product',
          brand: 'Test Brand',
        ));

    // act
    final result = await useCase(PriceLogParams(log: tPriceLog));

    // assert
    expect(result, const Right(null));
    verify(mockProductRepository.createIfNotExists(
      barcode: tPriceLog.productId,
      name: tPriceLog.marketName ?? "Bilinmiyor",
      brand: "Bilinmiyor",
    ));
    verify(mockRepository.submitPriceLog(tPriceLog));
    verifyNoMoreInteractions(mockRepository);
  });
}

