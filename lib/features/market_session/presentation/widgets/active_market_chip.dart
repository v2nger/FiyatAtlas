import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../market/presentation/views/market_selection_screen.dart';
import '../../market_session_provider.dart';

class ActiveMarketChip extends ConsumerWidget {
  const ActiveMarketChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMarketAsync = ref.watch(activeMarketProvider);

    return activeMarketAsync.when(
      data: (activeMarket) {
        if (activeMarket == null) {
          return ActionChip(
            avatar: const Icon(Icons.store_mall_directory_outlined, size: 16),
            label: const Text('Check In to Market'),
            onPressed: () => _goToMarketSelection(context),
            backgroundColor: Colors.white,
            elevation: 2,
          );
        }

        return InputChip(
          avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
          label: Text(
            activeMarket['market_name'] ?? 'Unknown Market',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal.shade50,
          deleteIcon: const Icon(
            Icons.exit_to_app,
            size: 16,
            color: Colors.red,
          ),
          onDeleted: () {
            _exitMarket(context, ref);
          },
          onPressed: () {
            // Re-select market
            _goToMarketSelection(context);
          },
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(child: LinearProgressIndicator()),
      ),
      error: (e, s) => const SizedBox(),
    );
  }

  void _goToMarketSelection(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MarketSelectionScreen()));
  }

  Future<void> _exitMarket(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Check Out?"),
        content: const Text(
          "Are you sure you want to end your shopping session at this market?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Check Out"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(marketSessionControllerProvider).exitMarket();
    }
  }
}
