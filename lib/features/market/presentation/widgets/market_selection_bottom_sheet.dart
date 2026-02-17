import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/active_market_provider.dart';

class MarketSelectionBottomSheet extends ConsumerStatefulWidget {
  const MarketSelectionBottomSheet({super.key});

  @override
  ConsumerState<MarketSelectionBottomSheet> createState() =>
      _MarketSelectionBottomSheetState();
}

class _MarketSelectionBottomSheetState
    extends ConsumerState<MarketSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _markets = [
    {"id": "migros", "name": "Migros"},
    {"id": "a101", "name": "A101"},
    {"id": "bim", "name": "BİM"},
    {"id": "sok", "name": "ŞOK"},
    {"id": "carrefour", "name": "CarrefourSA"},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _markets
        .where(
          (m) => m["name"]!.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Indicator
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Markete Girdim",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          /// Search
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Market ara...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 20),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final market = filtered[index];

                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(market["name"]!),
                  onTap: () {
                    enterMarket(
                      ref,
                      marketId: market["id"]!,
                      marketName: market["name"]!,
                    );

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
            label: const Text("Vazgeç"),
          ),
        ],
      ),
    );
  }
}
