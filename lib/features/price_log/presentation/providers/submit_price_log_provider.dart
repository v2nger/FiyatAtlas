import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared_providers.dart';
import '../../../market_session/market_session_provider.dart';
import '../../../product/data/product_remote_datasource.dart';
import '../../../product/data/repositories/product_repository_impl.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../data/datasources/price_log_local_datasource.dart';
import '../../data/datasources/price_log_remote_datasource.dart';
import '../../data/repositories/price_log_repository_impl.dart';
import '../../domain/entities/price_log.dart';
import '../../domain/repositories/price_log_repository.dart';
import '../../domain/usecases/submit_price_log_usecase.dart';

// ================= DATA SOURCES =================

// This provider is now conditionally exported
import 'price_log_local_datasource_provider.dart';

final priceLogLocalDataSourceProvider = priceLogDataSourceProvider;

final priceLogRemoteDataSourceProvider =
    Provider<PriceLogRemoteDataSource>((ref) {
  return PriceLogRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

// ================= REPOSITORY =================

final priceLogRepositoryProvider =
    Provider<PriceLogRepository>((ref) {
  return PriceLogRepositoryImpl(
    localDataSource: ref.watch(priceLogLocalDataSourceProvider),
    remoteDataSource: ref.watch(priceLogRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final productRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
  );
});

// ================= USE CASE =================

final submitPriceLogUseCaseProvider =
    Provider<SubmitPriceLog>((ref) {
  return SubmitPriceLog(
    priceLogRepository: ref.watch(priceLogRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
  );
});

// ================= CONTROLLER =================

class SubmitPriceLogState
    extends StateNotifier<AsyncValue<void>> {
  final SubmitPriceLog _useCase;
  final Ref ref;

  SubmitPriceLogState(this._useCase, this.ref)
      : super(const AsyncValue.data(null));

  Future<void> submit(PriceLog log) async {
    final activeMarket =
        ref.read(activeMarketProvider).value;

    if (activeMarket == null) {
      state = AsyncValue.error(
        "Lütfen önce bir market seçin.",
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    // Market otomatik inject
    final updatedLog = log.copyWith(
      marketId: activeMarket['market_id'],
      marketName: activeMarket['market_name'],
    );

    final result =
        await _useCase(PriceLogParams(log: updatedLog));

    result.fold(
      (failure) => state = AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

final submitPriceLogControllerProvider =
    StateNotifierProvider<
        SubmitPriceLogState,
        AsyncValue<void>>((ref) {
  return SubmitPriceLogState(
    ref.watch(submitPriceLogUseCaseProvider),
    ref,
  );
});

// ================= LOGS =================

final userPriceLogsProvider =
    FutureProvider<List<PriceLog>>((ref) async {
  final local =
      ref.watch(priceLogLocalDataSourceProvider);
  return local.getLastLogs();
});

final productHistoryProvider =
    FutureProvider.family<List<PriceLog>, String>(
        (ref, barcode) async {
  final local =
      ref.watch(priceLogLocalDataSourceProvider);
  return local.getLogsByProduct(barcode);
});
