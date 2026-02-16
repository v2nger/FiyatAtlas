import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'providers/market_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  // Default center: Kadıköy/Istanbul
  final LatLng _initialCenter = const LatLng(41.0082, 29.0410);

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(nearbyBranchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Haritası'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(_initialCenter, 13.0);
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: _initialCenter, initialZoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.fiyatatlas.app',
          ),
          branchesAsync.when(
            data: (branches) => MarkerLayer(
              markers: branches.map((branch) {
                return Marker(
                  point: LatLng(branch.latitude, branch.longitude),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showBranchDetails(branch),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            error: (e, s) => const MarkerLayer(markers: []), // Show nothing on error or show snackbar
            loading: () => const MarkerLayer(markers: []),
          ),
        ],
      ),
    );
  }

  void _showBranchDetails(MarketBranch branch) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branch.chainName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                branch.branchName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${branch.district}, ${branch.city}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Check in
                    ref.read(currentBranchProvider.notifier).state = branch;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${branch.branchName} seçildi.')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Burayı Seç (Check-in)'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
