import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiyatatlas/core/providers/auth_providers.dart';
import 'package:fiyatatlas/features/admin/presentation/views/leaderboard_view.dart';
import 'package:fiyatatlas/features/admin/presentation/views/user_management_view.dart';
import 'package:fiyatatlas/features/admin/presentation/views/verified_prices_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;

  Stream<Map<String, dynamic>?> activeMarketStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data()?["active_market"]);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final isFounder = user?.role == 'founder';

    final List<Widget> pages = [
      const VerifiedPricesView(),
      const LeaderboardView(),
      if (isFounder) const UserManagementView(),
    ];

    final List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Icons.price_check),
        label: 'Prices',
      ),
      const NavigationDestination(
        icon: Icon(Icons.leaderboard),
        label: 'Top Users',
      ),
      if (isFounder)
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
    ];

    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FiyatAtlas Dashboard'),
        backgroundColor: Colors.teal.shade900,
        actions: [
          StreamBuilder<Map<String, dynamic>?>(
            stream: activeMarketStream(),
            builder: (context, snapshot) {
              final market = snapshot.data;

              if (market == null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ActionChip(
                    backgroundColor: Colors.orange,
                    label: const Text(
                      "Market Seç",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // TODO: Market seçim ekranına yönlendir
                    },
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Chip(
                  backgroundColor: Colors.green.shade700,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.store, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        market["market_name"] ?? "Market",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        destinations: destinations,
      ),
    );
  }
}
