import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/price_log.dart';
import '../repositories/price_log_repository.dart';

class SubmitPriceLog implements UseCase<void, PriceLogParams> {
  final PriceLogRepository repository;

  SubmitPriceLog(this.repository);

  @override
  Future<Either<Failure, void>> call(PriceLogParams params) async {
    return await repository.submitPriceLog(params.log);
  }
}

class PriceLogParams extends Equatable {
  final PriceLog log;

  const PriceLogParams({required this.log});

  @override
  List<Object> get props => [log];
}
