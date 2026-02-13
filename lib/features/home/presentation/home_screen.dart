import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';
import 'package:fiyatatlas/core/presentation/widgets/app_logo.dart'; // Add this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final entries = appState.entries;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const AppLogo(height: 50),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Market Haritası',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Haftalık Özet Kartı
          Card(
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const _PointHistorySheet(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 40,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Toplam Puanın',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Text('1250 Puan (Bronz Üye)'),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+80',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Bu Hafta',
                          style: TextStyle(fontSize: 10, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Öne Çıkan Fırsatlar
          const Text(
            'Yakınındaki Fırsatlar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appState.products.take(5).length,
              itemBuilder: (context, index) {
                final product = appState.products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: product.barcode,
                    );
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Hero(
                            tag: 'product_img_${product.barcode}',
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.teal.shade200,
                              size: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${product.brand} ${product.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // 3. Son Girişler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Son Hareketler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('Tümü')),
            ],
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Henüz giriş yapılmadı.'),
            ),
          for (final entry in entries)
            _EntryTile(
              name: appState.products.any((p) => p.barcode == entry.barcode)
                  ? appState.products
                        .firstWhere((p) => p.barcode == entry.barcode)
                        .name
                  : 'Barkod: ${entry.barcode}',
              price: entry.price,
              status: entry.status,
              barcode: entry.barcode,
            ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.name,
    required this.price,
    required this.status,
    required this.barcode,
  });

  final String name;
  final double price;
  final PriceVerificationStatus status;
  final String barcode;

  @override
  Widget build(BuildContext context) {
    // Rastgele değişim simülasyonu (Veri olmadığı için)
    final bool isUp = barcode.hashCode % 2 == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            '/product-detail',
            arguments: barcode,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Resim / İkon Alanı
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Bilgi Alanı
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // Roboto Medium muadili
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  status ==
                                      PriceVerificationStatus.verifiedPublic
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status.label,
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    status ==
                                        PriceVerificationStatus.verifiedPublic
                                    ? Colors.green.shade700
                                    : Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Fiyat Alanı
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₺${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily:
                            'Montserrat', // Eğer font yüklü değilse fallback çalışır
                        fontSize: 20,
                        fontWeight: FontWeight.w900, // Extra Bold
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                          color: isUp ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        Text(
                          '%5', // Mock veri
                          style: TextStyle(
                            fontSize: 12,
                            color: isUp ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PointHistorySheet extends StatefulWidget {
  const _PointHistorySheet();

  @override
  State<_PointHistorySheet> createState() => _PointHistorySheetState();
}

class _PointHistorySheetState extends State<_PointHistorySheet> {
  int _selectedTab = 0; // 0: Hafta, 1: Ay, 2: Tümü

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Puan Hareketleri',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sekmeler
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Bu Hafta')),
              ButtonSegment(value: 1, label: Text('Bu Ay')),
              ButtonSegment(value: 2, label: Text('Tümü')),
            ],
            selected: {_selectedTab},
            onSelectionChanged: (newSelection) {
              setState(() => _selectedTab = newSelection.first);
            },
          ),
          const SizedBox(height: 16),

          // İçerik (Mock Veri)
          _buildContentForTab(_selectedTab),

          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTab == 0
                    ? 'Bu Hafta Toplam:'
                    : (_selectedTab == 1 ? 'Bu Ay Toplam:' : 'Genel Toplam:'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _selectedTab == 0
                    ? '80 Puan'
                    : (_selectedTab == 1 ? '340 Puan' : '1250 Puan'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForTab(int tabIndex) {
    // 0: Hafta, 1: Ay, 2: Tümü
    if (tabIndex == 0) {
      return Column(
        children: [
          _buildItem(
            Icons.qr_code,
            'Barkod Okutma',
            '+10 Puan',
            'Bugün, 14:30',
          ),
          _buildItem(Icons.receipt, 'Fiş Yükleme', '+50 Puan', 'Dün, 18:20'),
          _buildItem(
            Icons.info,
            'Eksik Bilgi Tamamlama',
            '+20 Puan',
            'Pazartesi',
          ),
        ],
      );
    } else if (tabIndex == 1) {
      return Column(
        children: [
          _buildItem(
            Icons.star,
            'Haftanın Lideri Bonusu',
            '+100 Puan',
            'Geçen Hafta',
          ),
          _buildItem(
            Icons.qr_code,
            'Barkod Okutma (x12)',
            '+120 Puan',
            '1-10 Şubat',
          ),
          _buildItem(Icons.receipt, 'Fiş Yükleme (x2)', '+100 Puan', '5 Şubat'),
          _buildItem(Icons.info, 'Eksik Bilgi', '+20 Puan', '1 Şubat'),
        ],
      );
    } else {
      return Column(
        children: [
          _buildItem(
            Icons.emoji_events,
            'Hoşgeldin Bonusu',
            '+250 Puan',
            'Ocak 2024',
          ),
          _buildItem(
            Icons.verified,
            'Profil Doğrulama',
            '+100 Puan',
            'Ocak 2024',
          ),
          _buildItem(
            Icons.history,
            'Ocak Ayı Aktiviteleri',
            '+560 Puan',
            'Ocak Toplam',
          ),
          _buildItem(
            Icons.history,
            'Şubat Ayı Aktiviteleri',
            '+340 Puan',
            'Şubat Toplam',
          ),
        ],
      );
    }
  }

  Widget _buildItem(IconData icon, String title, String points, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
