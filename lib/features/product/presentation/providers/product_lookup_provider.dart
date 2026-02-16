import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';

final productRepositoryProvider = Provider<ProductRepositoryImpl>((ref) {
  final remote = ProductRemoteDataSourceImpl(FirebaseFirestore.instance);
  return ProductRepositoryImpl(remoteDataSource: remote);
});

final productLookupProvider =
    FutureProvider.family<Product?, String>((ref, barcode) async {
  if (barcode.isEmpty) return null;

  final repo = ref.read(productRepositoryProvider);
  return await repo.getByBarcode(barcode);
});
