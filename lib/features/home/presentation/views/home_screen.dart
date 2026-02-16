import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/widgets/status_indicators.dart';
import '../../../market_session/presentation/widgets/active_market_chip.dart';
import '../../../price_log/domain/entities/price_log.dart';
import '../../../price_log/presentation/providers/submit_price_log_provider.dart';
import '../../../product/presentation/views/product_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentLogsAsync = ref.watch(userPriceLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FiyatAtlas'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ActiveMarketChip(),
          ),
        ],
      ),
      body: recentLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No recent price logs found.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              final log = logs[idx];
              return _PriceLogCard(log: log);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please use the "Submit" tab below.')),
          );
        },
        label: const Text('Scan Price'),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class _PriceLogCard extends StatelessWidget {
  final PriceLog log;

  const _PriceLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    // Confidence is not directly on PriceLog, simulating based on receipt
    final confidence = log.hasReceipt ? 0.9 : 0.5;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // For InkWell ripple
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: log.productId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      log.marketName ?? 'Unknown Market',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SyncIndicator(status: log.syncStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    log.productId, // Barcode
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('dd MMM HH:mm').format(log.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ConfidenceBadge(confidence: confidence),
                      const SizedBox(width: 8),
                      if (log.hasReceipt)
                        const Icon(Icons.receipt_long, size: 16, color: Colors.teal),
                    ],
                  ),
                  Text(
                    '${log.price.toStringAsFixed(2)} ${log.currency}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

