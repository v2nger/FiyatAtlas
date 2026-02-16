import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
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
    // WEB: Direct to Firestore (Bypass Isar)
    if (kIsWeb) {
      try {
        await remoteDataSource.submitPriceLog(log);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }

    // MOBILE: Offline-First Logic (Isar + Sync)
    // 1. Always save to local DB first (Optimistic UI support + Backup)
    try {
      // Local Persistence is the Single Source of Truth for the UI
      await localDataSource.cachePriceLog(log, isPending: true); 

      // 2. Try Push if Online (Best Effort)
      if (await networkInfo.isConnected) {
        try {
           // Prevent double submission if sync manager picks it up too fast?
           // Actually, we just try to push. If successful, mark synced.
           await remoteDataSource.submitPriceLog(log);
           await localDataSource.markAsSynced(log.id);
        } catch (e) {
           // Remote push failed.
           // Do NOT fail the operation. The user's intent is captured.
           // Background Sync Manager will handle retries.
           // Log error for analytics if needed.
        }
      }
      
      // ALWAYS return success if local save worked.
      return const Right(null);

    } on Exception catch (e) {
      // Only fail if LOCAL DB fails (Critical Error)
      return Left(DatabaseFailure('Local persistence failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PriceLog>>> getMyRecentLogs(String userId) async {
    // WEB: Direct to Firestore (Bypass Isar)
    if (kIsWeb) {
      // TODO: Implement direct fetch from remoteDataSource if needed for Web history
      // For now, return empty list or implement remote fetch in datasource
      // Assuming RemoteDataSource has a method for this, or we return empty to avoid crash
      return const Right([]); 
    }

    try {
      final logs = await localDataSource.getLastLogs();
      return Right(logs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
