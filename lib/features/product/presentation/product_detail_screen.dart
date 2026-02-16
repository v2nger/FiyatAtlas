import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../market/presentation/providers/market_providers.dart';
import '../../price_log/presentation/providers/submit_price_log_provider.dart';
import 'providers/product_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Arguments: barcode
    final barcode = ModalRoute.of(context)!.settings.arguments as String;
    final productAsync = ref.watch(productLookupProvider(barcode));
    
    // History
    final historyAsync = ref.watch(productHistoryProvider(barcode));
    
    // Nearby branches to resolve names (or full branch list if available)
    final branchesAsync = ref.watch(nearbyBranchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Detayı')),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text("Ürün bulunamadı."));
          }

          // In-memory data for now, or from DB
          final history = historyAsync.value ?? [];
          final lastPrice = history.isNotEmpty ? history.first.price : 0.0;
          final lastDate = history.isNotEmpty ? history.first.timestamp : DateTime.now();
          final formattedDate = DateFormat('dd MMM yyyy', 'tr_TR').format(lastDate);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Image, Name)
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(product.imageUrl!, fit: BoxFit.contain),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${product.brand} - ${product.category}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Son Fiyat:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 8),
                          if (history.isNotEmpty)
                          Text(
                            '${lastPrice.toStringAsFixed(2)} ₺',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                          else
                           const Text('Fiyat Yok', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      if (history.isNotEmpty)
                      Text(
                        'Tarih: $formattedDate',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Fiyat Geçmişi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                if (history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Henüz veri girişi yok.'),
                  )
                else
                  branchesAsync.when(
                    data: (branches) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final entry = history[index];
                          
                          // Resolve branch name
                          String branchName = "Bilinmeyen Market";
                          try {
                            if (branches.isNotEmpty) {
                               final b = branches.firstWhere((b) => b.id == entry.marketId);
                               branchName = "${b.chainName} (${b.branchName})";
                            } else {
                                branchName = "Market ID: ${entry.marketId}";
                            }
                          } catch (_) {
                            branchName = "Market ID: ${entry.marketId}";
                          }

                          final dateStr = DateFormat('dd MMM yyyy HH:mm', 'tr_TR').format(entry.timestamp);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.check, color: Colors.green),
                            ),
                            title: Text('${entry.price.toStringAsFixed(2)} ₺'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(branchName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(dateStr),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text("Error loading branches: $e"),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Hata: $e")),
      ),
    );
  }
}
