import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fiyatatlas/app_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  // 0: Product, 1: Market
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ürün veya Market Ara...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterTab(
                  label: 'Ürünler',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
              ),
              Expanded(
                child: _FilterTab(
                  label: 'Marketler',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildResults(appState),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(AppState appState) {
    if (_query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Yukarıdaki arama çubuğuna ürün veya market adı yazın.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    if (_selectedTab == 0) {
      final products = appState.searchProducts(_query);
      if (products.isEmpty) return const _EmptyState();
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: Text(p.name),
            subtitle: Text('${p.brand} (${p.category})'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/product-detail', arguments: p.barcode);
            },
          );
        },
      );
    } else {
      final branches = appState.searchBranches(_query);
      if (branches.isEmpty) return const _EmptyState();
      return ListView.builder(
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final b = branches[index];
          return ListTile(
            leading: const Icon(Icons.storefront),
            title: Text(b.displayName),
            subtitle: Text('${b.district}, ${b.city}'),
            trailing: const Icon(Icons.location_on_outlined), 
            onTap: () {
              // Market seçimi ve Check-in
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(b.displayName),
                  content: const Text('Bu markete check-in yapmak ister misiniz?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
                    FilledButton(
                      onPressed: () {
                        context.read<AppState>().setCheckIn(b);
                        Navigator.pop(ctx); // Close dialog
                        // Go to MainScreen -> PriceEntry tab (Index 2) or just show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${b.displayName} şubesine giriş yapıldı.')),
                        );
                      },
                      child: const Text('Check-in Yap'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sonuç bulunamadı.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
