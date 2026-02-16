import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/widgets/status_indicators.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../price_log/domain/entities/price_log.dart';
import '../providers/product_providers.dart';

// Mock Provider for demonstration until real one is hooked up
final productHistoryProvider = FutureProvider.family<List<PriceLog>, String>((ref, barcode) async {
  // TODO: Replace with real UseCase
  return [];
});

class ProductDetailScreen extends ConsumerWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Arguments: barcode from constructor OR route args
    final String barcode = productId ?? (ModalRoute.of(context)!.settings.arguments as String);
    final productAsync = ref.watch(productLookupProvider(barcode));
    
    // History
    final historyAsync = ref.watch(productHistoryProvider(barcode));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        centerTitle: true,
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
                   const SizedBox(height: 16),
                   Text("Ürün bulunamadı.", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary)),
                 ],
               ),
             );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Image + Name)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                        Hero(
                          tag: product.id,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(product.imageUrl!),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.inventory_2, size: 48, color: AppColors.textSecondary),
                        ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '${product.brand} • ${product.category}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fiyat Geçmişi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      historyAsync.when(
                        data: (history) {
                           if (history.isEmpty) {
                             return Container(
                               padding: const EdgeInsets.all(24),
                               decoration: BoxDecoration(
                                 color: AppColors.surface,
                                 borderRadius: BorderRadius.circular(16),
                                 border: Border.all(color: AppColors.border),
                               ),
                               child: const Center(
                                 child: Text(
                                   'Henüz fiyat girişi yok.',
                                   style: TextStyle(color: AppColors.textSecondary),
                                 ),
                               ),
                             );
                           }
                           
                           return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: history.length > 5 ? 5 : history.length, // Show max 5
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final entry = history[index];
                                final dateStr = DateFormat('dd MMM yyyy', 'tr_TR').format(entry.timestamp);
                                
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: AppColors.background,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.store, color: AppColors.textSecondary, size: 20),
                                    ),
                                    title: Text(
                                      "₺${entry.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${entry.marketName}\n$dateStr",
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                    trailing: const ConfidenceBadge(confidence: 0.95), // Mock confidence for now
                                  ),
                                );
                              },
                           );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.secondary)),
                        error: (e, s) => Text("Hata: $e", style: const TextStyle(color: AppColors.error)),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                             // Navigate back or to submit new price
                             Navigator.pop(context); // Or navigate to submit pre-filled
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("YENİ FİYAT EKLE"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.secondary)),
        error: (e, s) => Center(child: Text("Hata: $e", style: const TextStyle(color: AppColors.error))),
      ),
    );
  }
}
