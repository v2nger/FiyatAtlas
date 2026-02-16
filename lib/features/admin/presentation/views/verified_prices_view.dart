import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/admin_providers.dart';
import '../widgets/verified_price_card.dart';

class VerifiedPricesView extends ConsumerWidget {
  const VerifiedPricesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(verifiedPricesStreamProvider);

    return stream.when(
      data: (prices) {
        if (prices.isEmpty) {
          return const Center(child: Text("No verified prices found"));
        }
        return ListView.builder(
          itemCount: prices.length,
          itemBuilder: (context, index) {
            final priceData = prices[index];
            return VerifiedPriceCard(data: priceData);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error: $e')),
    );
  }
}
