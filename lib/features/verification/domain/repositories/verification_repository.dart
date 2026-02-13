import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/verified_price.dart';

abstract class VerificationRepository {
  Future<Either<Failure, VerifiedPrice?>> getVerifiedPrice(String barcode, String marketId);
  Future<Either<Failure, List<VerifiedPrice>>> searchVerifiedPrices(String barcode);
}
