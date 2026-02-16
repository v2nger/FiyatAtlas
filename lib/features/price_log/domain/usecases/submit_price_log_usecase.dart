import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../entities/price_log.dart';
import '../repositories/price_log_repository.dart';

class SubmitPriceLog {
  final PriceLogRepository priceLogRepository;
  final ProductRepository productRepository;

  SubmitPriceLog({
    required this.priceLogRepository,
    required this.productRepository,
  });

  Future<Either<Failure, void>> call(PriceLogParams params) async {
    try {
      // 1️⃣ Ürün yoksa oluştur
      await productRepository.createIfNotExists(
        barcode: params.log.productId,
        name: params.log.marketName ?? "Bilinmiyor",
        brand: "Bilinmiyor",
      );

      // 2️⃣ Price log gönder
      await priceLogRepository.submitPriceLog(params.log);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class PriceLogParams {
  final PriceLog log;

  PriceLogParams({required this.log});
}
