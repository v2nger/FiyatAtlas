import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/product/domain/product.dart';
import 'package:fiyatatlas/core/presentation/widgets/price_chart.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Route args'dan barkodu al
    final barcode = ModalRoute.of(context)!.settings.arguments as String;
    
    final appState = context.watch<AppState>();
    
    // Ürünü bul
    Product? product;
    try {
      product = appState.products.firstWhere((p) => p.barcode == barcode);
    } catch (_) {
      // Bulunamazsa
    }

    // Fiyat geçmişini bul
    final history = appState.entries.where((e) => e.barcode == barcode).toList();
    // Tarihe göre sırala (Yeni en üstte)
    history.sort((a, b) => b.entryDate.compareTo(a.entryDate));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ürün Bulunamadı')),
        body: const Center(child: Text('Hata: Ürün verisi yok')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Hero Image Header
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.shade100,
              child: Center(
                child: Hero(
                  tag: 'product_img_$barcode',
                  child: Icon(Icons.shopping_bag, size: 100, color: Colors.teal.shade200),
                ),
              ),
            ),

            // Ürün Başlık Kartı
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(product.name, style: Theme.of(context).textTheme.headlineSmall)),
                        if (history.isNotEmpty)
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                             decoration: BoxDecoration(
                               color: Colors.green,
                               borderRadius: BorderRadius.circular(20),
                             ),
                             child: Text(
                               '${history.first.price} ₺',
                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                             ),
                           ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${product.brand} • ${product.category}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                       children: [
                         const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                         const SizedBox(width: 4),
                         Text(barcode, style: Theme.of(context).textTheme.bodySmall),
                       ],
                    ),

                    if (history.isNotEmpty) ...[
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('En Düşük', '${history.map((e) => e.price).reduce((a, b) => a < b ? a : b)} ₺', Colors.green),
                          _buildStat('Ortalama', '${(history.map((e) => e.price).reduce((a, b) => a + b) / history.length).toStringAsFixed(2)} ₺', Colors.orange),
                          _buildStat('En Yüksek', '${history.map((e) => e.price).reduce((a, b) => a > b ? a : b)} ₺', Colors.red),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Fiyat Analiz Grafiği
            if (history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                   height: 200,
                   child: PriceChart(history: history),
                ),
              ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Fiyat & Stok Geçmişi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            if (history.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Henüz veri girişi yok.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final entry = history[index];
                  // Market ismini bulalım (Branch ID'den)
                  final branch = appState.branches.firstWhere(
                    (b) => b.id == entry.marketBranchId,
                  );
                  // Tarih formatı
                  final dateStr = DateFormat('dd MMM yyyy HH:mm', 'tr_TR').format(entry.entryDate);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        entry.isAvailable ? Icons.check : Icons.close,
                        color: entry.isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text('${entry.price.toStringAsFixed(2)} ₺'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('${branch.chainName} - ${branch.branchName}'),
                         Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: entry.hasReceipt 
                      ? const Tooltip(message: 'Fişli Doğrulama', child: Icon(Icons.receipt, color: Colors.blue))
                      : null,
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Bu barkod için fiyat girişi ekranını aç
          // Not: PriceEntryScreen'e parametre geçme yapımız henüz yok, 
          // Oraya barkod geçebilmek için price_entry_screen.dart'ı güncellememiz gerekir.
          // Şimdilik sadece açalım.
          Navigator.pushNamed(context, '/price-entry');
        },
        label: const Text('Fiyat Gir'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
