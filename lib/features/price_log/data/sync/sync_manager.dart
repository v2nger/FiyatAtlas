import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/price_log_local_datasource.dart';
import '../datasources/price_log_remote_datasource.dart';

class PriceLogSyncManager {
  final PriceLogLocalDataSource localDataSource;
  final PriceLogRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  // Keep subscription to cancel if needed (though singleton usually lives forever)
  // ignored for this implementation

  PriceLogSyncManager({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Call this on app startup
  void init() {
    // 1. periodic check or connectivity listener
    // For simplicity, we just check once on init, 
    // real production apps use Connectivity().onConnectivityChanged or WorkManager
    syncPendingLogs();
  }

  Future<void> syncPendingLogs() async {
    if (!await networkInfo.isConnected) return;

    final pending = await localDataSource.getPendingLogs();
    if (pending.isEmpty) return;

    debugPrint('Syncing ${pending.length} logs...');

    for (var logModel in pending) {
      try {
        final entity = logModel.toEntity();
        await remoteDataSource.submitPriceLog(entity);
        await localDataSource.markAsSynced(logModel.uuid);
        debugPrint('Synced log: ${logModel.uuid}');
      } catch (e) {
        debugPrint('Failed to sync log ${logModel.uuid}: $e');
        // Stop on error to respect order or continue? 
        // Continue is better for independent logs.
      }
    }
  }
}
