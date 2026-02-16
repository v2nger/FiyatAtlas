import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product?> getByBarcode(String barcode);

  /// Ürün yoksa oluşturur, varsa mevcut ürünü döner.
  Future<Product> createIfNotExists({
    required String barcode,
    required String name,
    required String brand,
  });
}
