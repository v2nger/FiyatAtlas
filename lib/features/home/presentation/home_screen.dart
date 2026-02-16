import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/widgets/app_logo.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../price/domain/price_status.dart';

// Needs a provider to fetch recent entries. 
// For now, we stub this list or implement a provider for it.
final recentEntriesProvider = FutureProvider<List<dynamic>>((ref) async {
  // TODO: Implement getRecentEntries UseCase
  return [];
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final entriesAsync = ref.watch(recentEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const AppLogo(height: 40), 
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            icon: const Icon(Icons.map_outlined, color: AppColors.textSecondary),
            tooltip: 'Market Haritası',
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.notification, 
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Haftalık Özet Kartı
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)], // Dark metallic
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) => const _PointHistorySheet(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          size: 32,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Toplam Puanın',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user != null 
                                ? '${user.points} Puan' 
                                : 'Giriş Yapılmadı',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '+80',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Bu Hafta',
                              style: TextStyle(fontSize: 10, color: AppColors.success.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 2. Öne Çıkan Fırsatlar (Placeholder for now)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yakınındaki Fırsatlar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          // TODO: Replace with Riverpod Promoted Products Provider
          /*
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 0, // Placeholder
              itemBuilder: (context, index) {
                // ...
              return SizedBox();
              },
            ),
          ),
          */
          // Placeholder card
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: const Text("Yakınında fırsat bulunamadı", style: TextStyle(color: AppColors.textSecondary)),
          ),

          const SizedBox(height: 32),

          // 3. Son Girişler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son Hareketler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {}, 
                style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                child: const Text('Tümü')
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, color: AppColors.textTertiary, size: 40),
                        SizedBox(height: 8),
                        Text('Henüz giriş yapılmadı.', style: TextStyle(color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                   // Mock mapping for now to satisfy unused element warning
                   return const _EntryTile(
                     name: 'Ürün Name',
                     price: 0.0,
                     status: PriceVerificationStatus.pendingPrivate,
                     barcode: '000000',
                   );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.secondary)),
            error: (err, stack) => Text('Hata: $err', style: const TextStyle(color: AppColors.error)),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: AppColors.textSecondary,
                      size: 24,
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
                          fontWeight: FontWeight.w600, 
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  status == PriceVerificationStatus.verifiedPublic
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: status == PriceVerificationStatus.verifiedPublic
                                    ? AppColors.success.withValues(alpha: 0.3)
                                    : AppColors.warning.withValues(alpha: 0.3),
                              )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  status == PriceVerificationStatus.verifiedPublic ? Icons.check_circle : Icons.pending,
                                  size: 10,
                                  color: status == PriceVerificationStatus.verifiedPublic
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        status == PriceVerificationStatus.verifiedPublic
                                            ? AppColors.success
                                            : AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w900, 
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                          color: isUp ? AppColors.success : AppColors.error,
                          size: 16,
                        ),
                        Text(
                          '%5', // Mock veri
                          style: TextStyle(
                            fontSize: 12,
                            color: isUp ? AppColors.success : AppColors.error,
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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history, color: AppColors.gold),
              ),
              const SizedBox(width: 12),
              Text(
                'Puan Hareketleri',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
            style: ButtonStyle(
               backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.secondary;
                }
                return AppColors.background;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return AppColors.textSecondary;
              }),
            ),
          ),
          const SizedBox(height: 24),

          // İçerik (Mock Veri)
          _buildContentForTab(_selectedTab),

          const Divider(height: 32, color: AppColors.border),
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
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                _selectedTab == 0
                    ? '80 Puan'
                    : (_selectedTab == 1 ? '340 Puan' : '1250 Puan'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  date,
                  style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
