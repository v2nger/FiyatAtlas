import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/price_log.dart';

abstract class PriceLogRemoteDataSource {
  Future<void> submitPriceLog(PriceLog log);
}

class PriceLogRemoteDataSourceImpl implements PriceLogRemoteDataSource {
  final FirebaseFirestore firestore;

  PriceLogRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> submitPriceLog(PriceLog log) async {
    final map = {
      // Backend required fields
      'product_id': log.productId,
      'market_id': log.marketId,
      'user_id': log.userId,
      'price': log.price,
      'timestamp': Timestamp.fromDate(log.timestamp),
      'receipt_url': log.receiptImageUrl,
      'device_hash': log.deviceHash,

      // Default state (backend update edecek)
      'status': 'pending',
      'confidence_score': 0,

      // Optional UI fields
      'market_name': log.marketName,
      'currency': log.currency,
      'has_receipt': log.hasReceipt,
      'is_available': log.isAvailable,

      // Server clock
      'server_timestamp': FieldValue.serverTimestamp(),
    };

    await firestore.collection('price_logs').add(map);
  }
}
