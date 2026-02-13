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
    // Convert to Firestore Map
    final map = {
      'id': log.id,
      'userId': log.userId,
      'barcode': log.productId, // Schema requirement
      'marketBranchId': log.marketId,
      'price': log.price,
      'currency': log.currency,
      'entryDate': log.timestamp.toIso8601String(),
      'hasReceipt': log.hasReceipt,
      'receiptImageUrl': log.receiptImageUrl,
      'isAvailable': log.isAvailable,
      // Note: No confidence fields here. Backend handles that.
      'device_timestamp': FieldValue.serverTimestamp(),
    };

    await firestore.collection('price_logs').add(map);
  }
}
