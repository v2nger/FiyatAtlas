import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verified_price.dart';
import '../repositories/verification_repository.dart';

class GetVerifiedPrices implements UseCase<List<VerifiedPrice>, String> {
  final VerificationRepository repository;

  GetVerifiedPrices(this.repository);

  @override
  Future<Either<Failure, List<VerifiedPrice>>> call(
    String barcodeParams,
  ) async {
    return await repository.searchVerifiedPrices(barcodeParams);
  }
}
