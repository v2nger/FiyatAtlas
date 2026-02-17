import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/god_mode_providers.dart';

class GodModePanel extends ConsumerWidget {
  const GodModePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(godStatsProvider);
    final pendingAsync = ref.watch(pendingProductsProvider);
    final invisible = ref.watch(invisibleModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('👑 GOD MODE'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          Row(
            children: [
              const Text('Invisible'),
              Switch(
                value: invisible,
                onChanged: (val) {
                  ref.read(invisibleModeProvider.notifier).state = val;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(val ? '👻 Invisible Mode ON' : '👀 Visible Mode')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Global Metrics
            statsAsync.when(
              data: (stats) => _GlobalMetricsCard(stats: stats),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),

            // Pending Queue
            const Text(
              'Pending Verification Queue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            pendingAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No pending products! Great job 🚀'),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (ctx, idx) => _PendingProductTile(
                    product: products[idx],
                    onVerify: () => _verifyProduct(context, products[idx]['id']),
                  ),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyProduct(BuildContext context, String productId) async {
    try {
      // Force verify via direct write (God privileges assumed in Firestore rules)
      // Alternatively, call a cloud function if rules restrict writes.
      await FirebaseFirestore.instance.collection('products').doc(productId).update({
        'status': 'verified',
        'verifiedBy': 'GOD_MODE_ADMIN',
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Product Verified!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _GlobalMetricsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _GlobalMetricsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              icon: Icons.people,
              label: 'Users',
              value: (stats['totalUsers'] ?? 0).toString(),
              color: Colors.blueAccent,
            ),
            _StatItem(
              icon: Icons.shopping_bag,
              label: 'Products',
              value: (stats['totalProducts'] ?? 0).toString(),
              color: Colors.greenAccent,
            ),
             _StatItem(
              icon: Icons.pending_actions,
              label: 'Pending',
              value: (stats['pendingCount'] ?? 0).toString(),
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _PendingProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onVerify;

  const _PendingProductTile({required this.product, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: product['imageUrl'] != null 
            ? Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(product['name'] ?? 'Unknown Product'),
        subtitle: Text('Barcode: ${product['barcode'] ?? 'N/A'}'),
        trailing: ElevatedButton.icon(
          onPressed: onVerify,
          icon: const Icon(Icons.check, size: 16),
          label: const Text('Verify'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
