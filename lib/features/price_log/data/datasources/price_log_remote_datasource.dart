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
      'user_id': log.userId,
      'product_id': log.productId,
      'market_id': log.marketId,
      'market_name': log.marketName,
      'price': log.price,
      'currency': log.currency,
      'timestamp': log.timestamp,
      'device_timestamp':
          log.timestamp, // Ensure backend gets this if it expects it separately
      'receipt_url': log.receiptImageUrl,
      'receipt_raw_text': log.receiptRawText,
      'device_hash': log.deviceHash,
      'status': 'private',
      'created_at': FieldValue.serverTimestamp(),
    };

    await firestore.collection('price_logs').add(map);
  }
}
