import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../price_log/presentation/providers/submit_price_log_provider.dart';

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming we want to show logs that are "pending" or just recent logs
    // The legacy code filtered for 'not verifiedPublic'
    final logsAsync = ref.watch(userPriceLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Doğrulama Durumu')),
      body: logsAsync.when(
        data: (entries) {
          // Replicate legacy logic: Filter for items that are not verified yet (mock logic mostly)
          // Since PriceLog usually doesn't have status, we assume all local logs are 'pending' verification in this mock context unless syncStatus changes
          // But here we just show what we have.

          final pending = entries; // Show all history for now

          if (pending.isEmpty) {
            return const Center(
              child: Card(
                margin: EdgeInsets.all(16),
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text('Bekleyen doğrulama yok'),
                  subtitle: Text('Yeni fiyat girişlerini takip edin.'),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Bekleyen doğrulamalar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final entry in pending)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.pending_actions),
                    title: Text(
                      'Ürün ID: ${entry.productId}',
                    ), // Use product lookup if needed for name
                    subtitle: Text('Market ID: ${entry.marketId}'),
                    trailing: Text('${entry.price.toStringAsFixed(2)} ₺'),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
