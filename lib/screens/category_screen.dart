import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final products = appState.products;
    
    // Kategorileri çıkar
    final categories = products.map((p) => p.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          // Bu kategorideki ürün sayısı
          final productCount = products.where((p) => p.category == category).length;

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.category),
            ),
            title: Text(category),
            subtitle: Text('$productCount Ürün'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Kategori detayına git (filtreli ürün listesi)
              // Şimdilik SearchScreen'e filtreyle gönderebiliriz ama
              // Kullanıcı "Kategorilere göre ürünleri görüp" dedi,
              // Bu yüzden basit bir listeleme sayfası yapalım inline.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _CategoryProductList(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryProductList extends StatelessWidget {
  const _CategoryProductList({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final products = appState.products.where((p) => p.category == category).toList();

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
                arguments: product.barcode, // Barkod ile detaya git
              );
            },
          );
        },
      ),
    );
  }
}
