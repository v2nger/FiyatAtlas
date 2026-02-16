import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/market/presentation/providers/market_providers.dart';
import 'package:fiyatatlas/features/product/presentation/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  // 0: Product, 1: Market
  int _selectedTab = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: _query.isEmpty 
              ? const _SearchIdle()
              : _buildResults(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, WidgetRef ref) {
    if (_selectedTab == 0) {
      final productsAsync = ref.watch(productSearchProvider(_query));

      return productsAsync.when(
        data: (products) {
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      );
    } else {
      final branchesAsync = ref.watch(branchSearchProvider(_query));

      return branchesAsync.when(
        data: (branches) {
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
                  _showCheckInDialog(context, ref, b);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      );
    }
  }

  void _showCheckInDialog(BuildContext context, WidgetRef ref, MarketBranch b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(b.displayName),
        content: const Text('Bu markete check-in yapmak ister misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () {
              ref.read(currentBranchProvider.notifier).state = b;
              Navigator.pop(ctx); 
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${b.displayName} şubesine giriş yapıldı.')),
              );
            },
            child: const Text('Check-in Yap'),
          ),
        ],
      ),
    );
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _SearchIdle extends StatelessWidget {
  const _SearchIdle();

  @override
  Widget build(BuildContext context) {
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
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sonuç bulunamadı.'));
  }
}
