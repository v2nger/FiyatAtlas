import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<Product?> fetchProductByBarcode(String barcode);
  Future<void> createProduct(Product product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;

  ProductRemoteDataSourceImpl(this.firestore)
    : functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Future<Product?> fetchProductByBarcode(String barcode) async {
    final snapshot = await firestore
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first.data();

    return Product(
      barcode: data['barcode'] ?? barcode,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt:
          (data['created_at'] as Timestamp?)?.toDate() ??
          (data['createdAt'] as Timestamp?)?.toDate(),
      createdBy: data['created_by'] ?? data['createdBy'],
    );
  }

  @override
  Future<void> createProduct(Product product) async {
    // Moved to Backend via Callable Function for security/abuse prevention
    try {
      final result = await functions.httpsCallable('createProduct').call({
        'barcode': product.barcode,
        'name': product.name,
        'brand': product.brand,
        'imageUrl': product.imageUrl,
      });

      if (result.data['success'] != true) {
        throw FirebaseException(
          plugin: 'cloud_functions',
          message: result.data['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      // Fallback or rethrow? Rethrow so UI can show error.
      // If offline, this will fail. Queueing product creation is harder.
      // For now, fail fast as per "Data Integrity Fix".
      rethrow;
    }
  }
}
