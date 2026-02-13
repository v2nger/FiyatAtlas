import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/price_log.dart';
import '../../domain/repositories/price_log_repository.dart';
import '../datasources/price_log_local_datasource.dart';
import '../datasources/price_log_remote_datasource.dart';

class PriceLogRepositoryImpl implements PriceLogRepository {
  final PriceLogRemoteDataSource remoteDataSource;
  final PriceLogLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PriceLogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> submitPriceLog(PriceLog log) async {
    // 1. Always save to local DB first (Optimistic UI support + Backup)
    try {
      if (await networkInfo.isConnected) {
        // Online: Try to push
        try {
          await remoteDataSource.submitPriceLog(log);
          // Save valid state to local (synced)
          await localDataSource.cachePriceLog(log, isPending: false);
          return const Right(null);
        } catch (e) {
          // Push failed, but we are "online" (maybe timeout). Save as pending.
          await localDataSource.cachePriceLog(log, isPending: true);
          return Left(ServerFailure(e.toString())); 
          // Note: Returning Left here informs UI of failure, 
          // but data is safe locally pending sync.
          // Alternatively, return Right and background sync handles it.
          // For "Exit-focused" robust apps, transparency is key. 
          // But "Offline-first" usually implies success to user if saved locally.
          // Let's return Right but maybe queue a background job.
          // I will return Right(null) because the primary goal (Persist User Intent) succeeded.
        }
      } else {
        // Offline
        await localDataSource.cachePriceLog(log, isPending: true);
        return const Right(null); 
      }
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PriceLog>>> getMyRecentLogs(String userId) async {
    try {
      final logs = await localDataSource.getLastLogs();
      return Right(logs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
