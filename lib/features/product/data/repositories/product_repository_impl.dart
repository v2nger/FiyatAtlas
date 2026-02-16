import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product?> getByBarcode(String barcode) {
    return remoteDataSource.fetchProductByBarcode(barcode);
  }

  @override
  Future<Product> createIfNotExists({
    required String barcode,
    required String name,
    required String brand,
  }) async {
    final existing = await remoteDataSource.fetchProductByBarcode(barcode);
    if (existing != null) {
      return existing;
    }

    final newProduct = Product(
      barcode: barcode,
      name: name,
      brand: brand,
      createdAt: DateTime.now(),
      source: 'User',
    );

    await remoteDataSource.createProduct(newProduct);
    return newProduct;
  }
}
