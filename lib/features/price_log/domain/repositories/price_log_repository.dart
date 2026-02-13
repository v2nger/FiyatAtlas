import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/price_log.dart';

abstract class PriceLogRepository {
  /// Submits a price log.
  /// 
  /// In offline-first architecture, this:
  /// 1. Saves to Local DB always.
  /// 2. If online -> Pushes to Remote and updates sync status.
  /// 3. If offline -> Marks as 'pending_sync' in Local DB.
  Future<Either<Failure, void>> submitPriceLog(PriceLog log);

  /// Gets recent logs (e.g., for history).
  Future<Either<Failure, List<PriceLog>>> getMyRecentLogs(String userId);
}
