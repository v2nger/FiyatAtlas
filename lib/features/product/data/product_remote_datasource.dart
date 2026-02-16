import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<Product?> fetchProductByBarcode(String barcode);
  Future<void> createProduct(Product product);
}

class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      createdBy: data['createdBy'],
    );
  }

  @override
  Future<void> createProduct(Product product) async {
    await firestore.collection('products').add({
      'barcode': product.barcode,
      'name': product.name,
      'brand': product.brand,
      'imageUrl': product.imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
