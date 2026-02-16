import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared_providers.dart';
import '../../data/product_lookup_service.dart';
import '../../domain/entities/product.dart';

// Service
final productLookupServiceProvider = Provider<ProductLookupService>((ref) {
  return ProductLookupService();
});

// Single Product Fetch Logic
// This replicates AppState.lookupProduct with caching/api fallback
final productLookupProvider = FutureProvider.family<Product?, String>((ref, barcode) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final lookupService = ref.watch(productLookupServiceProvider);

  // 1. Check DB
  final existing = await firestoreService.getProduct(barcode);
  if (existing != null) return existing;

  // 2. Check API
  final apiProduct = await lookupService.lookupBarcode(barcode);
  if (apiProduct != null) {
    // 3. Save to DB
    await firestoreService.addProduct(apiProduct);
    return apiProduct;
  }
  
  return null;
});

// Search Logic
final productSearchProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.searchProducts(query);
});

final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAllProducts();
});
