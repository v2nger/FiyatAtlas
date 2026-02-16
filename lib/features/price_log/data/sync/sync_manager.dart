import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/price_log_local_datasource.dart';
import '../datasources/price_log_remote_datasource.dart';

class PriceLogSyncManager {
  final PriceLogLocalDataSource localDataSource;
  final PriceLogRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  // Retry Logic Configuration
  static const int maxRetries = 5;
  static const int initialDelaySeconds = 2;
  bool _isSyncing = false;
  Timer? _retryTimer;

  PriceLogSyncManager({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Initializes background sync
  void init() {
    // Initial Sync
    syncPendingLogs();
    
    // Listen for connectivity changes could be added here if stream is available
  }

  /// Triggers the sync process with exponential backoff
  Future<void> syncPendingLogs({int retryCount = 0}) async {
    if (_isSyncing) return;
    
    // Check connectivity
    if (!await networkInfo.isConnected) return;

    _isSyncing = true;
    
    try {
      final pending = await localDataSource.getPendingLogs();
      if (pending.isEmpty) {
        _isSyncing = false;
        return;
      }

      debugPrint('SyncManager: Processing ${pending.length} logs...');

      bool anyFailed = false;

      for (var logModel in pending) {
        try {
          final entity = logModel.toEntity();
          // Check for Duplicates / Rate Limiting (Optimistic)
          // Ideally check remote if it already exists, but for Append-Only logs, 
          // we can rely on ID idempotency if the ID is preserved.
          
          await remoteDataSource.submitPriceLog(entity);
          await localDataSource.markAsSynced(logModel.uuid);
          debugPrint('SyncManager: Synced ${logModel.uuid}');
        } catch (e) {
          debugPrint('SyncManager: Failed log ${logModel.uuid}: $e');
          anyFailed = true;
          // Don't stop the loop, try others
        }
      }

      if (anyFailed && retryCount < maxRetries) {
        // Exponential Backoff
        final delay = initialDelaySeconds * pow(2, retryCount).toInt();
        debugPrint('SyncManager: Retrying in $delay seconds (Attempt ${retryCount + 1})');
        
        _retryTimer?.cancel();
        _retryTimer = Timer(Duration(seconds: delay), () {
           _isSyncing = false; 
           syncPendingLogs(retryCount: retryCount + 1);
        });
        return; // Return here, callback will handle reset of _isSyncing
      }

    } finally {
      // If we didn't schedule a retry, free the lock
      if (_retryTimer == null || !_retryTimer!.isActive) {
        _isSyncing = false;
      }
    }
  }
}
