import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../market_session/market_session_provider.dart';
import '../../domain/market_branch.dart';
import '../providers/market_providers.dart';

class MarketSelectionScreen extends ConsumerStatefulWidget {
  const MarketSelectionScreen({super.key});

  @override
  ConsumerState<MarketSelectionScreen> createState() =>
      _MarketSelectionScreenState();
}

class _MarketSelectionScreenState extends ConsumerState<MarketSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  // Mock initial center (Istanbul)
  final LatLng _initialCenter = const LatLng(41.0082, 28.9784);

  List<MarketBranch> _filteredBranches = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, List<MarketBranch> allBranches) {
    if (query.isEmpty) {
      setState(() {
        _filteredBranches = allBranches;
      });
    } else {
      final lowerQuery = query.toLowerCase();
      setState(() {
        _filteredBranches = allBranches.where((branch) {
          return branch.displayName.toLowerCase().contains(lowerQuery) ||
              branch.city.toLowerCase().contains(lowerQuery) ||
              branch.district.toLowerCase().contains(lowerQuery);
        }).toList();
      });
    }
  }

  Future<void> _selectMarket(MarketBranch branch) async {
    // Check-in via MarketSessionController
    try {
      final controller = ref.read(marketSessionControllerProvider);
      await controller.enterMarket(
        marketId: branch.id,
        marketName: branch.displayName,
        lat: branch.latitude,
        lng: branch.longitude,
      );

      // Also update local state for UI sync if needed
      ref.read(currentBranchProvider.notifier).state = branch;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checked in to ${branch.displayName}")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Check-in failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(nearbyBranchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Market'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "List", icon: Icon(Icons.list)),
            Tab(text: "Map", icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: branchesAsync.when(
        data: (originalBranches) {
          // Initialize filtered list if empty and clean slate
          if (_filteredBranches.isEmpty && _searchController.text.isEmpty) {
            _filteredBranches = originalBranches;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _onSearchChanged(val, originalBranches),
                  decoration: InputDecoration(
                    hintText: "Search markets...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // LIST VIEW
                    _buildListView(),

                    // MAP VIEW
                    _buildMapView(),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildListView() {
    if (_filteredBranches.isEmpty) {
      return const Center(child: Text("No markets found"));
    }
    return ListView.separated(
      itemCount: _filteredBranches.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final branch = _filteredBranches[index];
        final isSelected = ref.watch(currentBranchProvider)?.id == branch.id;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal.shade100,
            child: Text(
              branch.chainName.isNotEmpty
                  ? branch.chainName[0].toUpperCase()
                  : "?",
            ),
          ),
          title: Text(branch.displayName),
          subtitle: Text("${branch.district}, ${branch.city}"),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.chevron_right),
          onTap: () => _selectMarket(branch),
        );
      },
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _filteredBranches.isNotEmpty
            ? LatLng(
                _filteredBranches.first.latitude,
                _filteredBranches.first.longitude,
              )
            : _initialCenter,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.fiyatatlas.app',
        ),
        MarkerLayer(
          markers: _filteredBranches.map((branch) {
            final isSelected =
                ref.watch(currentBranchProvider)?.id == branch.id;
            return Marker(
              point: LatLng(branch.latitude, branch.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => _buildMarketDetailSheet(branch),
                  );
                },
                child: Icon(
                  Icons.location_on,
                  color: isSelected ? Colors.green : Colors.red,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
        // Simple attribution
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }

  Widget _buildMarketDetailSheet(MarketBranch branch) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            branch.displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("${branch.district}, ${branch.city}"),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _selectMarket(branch);
            },
            icon: const Icon(Icons.login),
            label: const Text("CHECK IN HERE"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
