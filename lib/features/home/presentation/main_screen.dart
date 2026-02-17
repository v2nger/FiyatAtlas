import 'package:flutter/material.dart';

import '../../auth/presentation/profile_screen.dart';
import '../../product/presentation/category_screen.dart';
import '../../product/presentation/scan_screen.dart';
import '../../product/presentation/search_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _mainTabs = [
    const HomeScreen(),
    const SearchScreen(),
    const CategoryScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the body content based on the selected index
    // We treat the Scan page (index 2) specially to ensure the camera lifecycle is managed correctly.
    // When switching away from index 2, the ScanScreen is removed from the tree, disposing the camera.

    Widget bodyContent;

    if (_selectedIndex == 2) {
      // The Scan Screen (Camera)
      bodyContent = const ScanScreen();
    } else {
      // For tabs 0, 1, 3, 4, we map them to the corresponding index in _mainTabs
      // 0 -> 0 (Home)
      // 1 -> 1 (Search)
      // 3 -> 2 (Category)
      // 4 -> 3 (Profile)

      int tabIndex = _selectedIndex;
      if (tabIndex > 2) {
        tabIndex--; // Adjust for the missing Scan tab in the list
      }

      bodyContent = IndexedStack(index: tabIndex, children: _mainTabs);
    }

    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Ara',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Ekle',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Kategoriler',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
