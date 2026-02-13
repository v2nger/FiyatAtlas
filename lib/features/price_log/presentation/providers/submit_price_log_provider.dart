import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared_providers.dart';
import '../../data/datasources/price_log_local_datasource.dart';
import '../../data/datasources/price_log_remote_datasource.dart';
import '../../data/repositories/price_log_repository_impl.dart';
import '../../domain/repositories/price_log_repository.dart';
import '../../domain/usecases/submit_price_log_usecase.dart';
import '../../domain/entities/price_log.dart';

// Data Sources
final priceLogLocalDataSourceProvider = Provider<PriceLogLocalDataSource>((ref) {
  return PriceLogLocalDataSourceImpl(ref.watch(isarProvider));
});

final priceLogRemoteDataSourceProvider = Provider<PriceLogRemoteDataSource>((ref) {
  return PriceLogRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

// Repository
final priceLogRepositoryProvider = Provider<PriceLogRepository>((ref) {
  return PriceLogRepositoryImpl(
    localDataSource: ref.watch(priceLogLocalDataSourceProvider),
    remoteDataSource: ref.watch(priceLogRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// Use Cases
final submitPriceLogUseCaseProvider = Provider<SubmitPriceLog>((ref) {
  return SubmitPriceLog(ref.watch(priceLogRepositoryProvider));
});

// StateNotifier (Controller)
class SubmitPriceLogState extends StateNotifier<AsyncValue<void>> {
  final SubmitPriceLog _useCase;

  SubmitPriceLogState(this._useCase) : super(const AsyncValue.data(null));

  Future<void> submit(PriceLog log) async {
    state = const AsyncValue.loading();
    final result = await _useCase(PriceLogParams(log: log));
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

final submitPriceLogControllerProvider = StateNotifierProvider<SubmitPriceLogState, AsyncValue<void>>((ref) {
  return SubmitPriceLogState(ref.watch(submitPriceLogUseCaseProvider));
});
