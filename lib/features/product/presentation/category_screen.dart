import 'package:fiyatatlas/features/product/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/product_providers.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
             return const Center(child: Text("Hencüz ürün bulunmamaktadır."));
          }
           // Unique categories
          final categories = products.map((p) => p.category).toSet().toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              // Count products in this category
              final productCount = products.where((p) => p.category == category).length;

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.category),
                ),
                title: Text(category),
                subtitle: Text('$productCount Ürün'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _CategoryProductList(
                        category: category, 
                        products: products.where((p) => p.category == category).toList()
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Yüklenirken hata oluştu: $e")),
      )
    );
  }
}

class _CategoryProductList extends StatelessWidget {
  const _CategoryProductList({required this.category, required this.products});

  final String category;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.brand} - ${product.barcode}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
               Navigator.pushNamed(
                context, 
                '/product-detail',
                arguments: product.barcode, 
              );
            },
          );
        },
      ),
    );
  }
}
