import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../market_session_provider.dart';

class ActiveMarketBanner extends ConsumerWidget {
  const ActiveMarketBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketAsync = ref.watch(activeMarketProvider);
    final controller = ref.read(marketSessionControllerProvider);

    return marketAsync.when(
      data: (market) {
        if (market == null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Market selection screen'e yönlendir
              },
              child: const Text("Markete Gir"),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.teal.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "🛒 ${market["market_name"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await controller.exitMarket();
                },
                child: const Text("Çık", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, _) => const SizedBox(),
    );
  }
}
