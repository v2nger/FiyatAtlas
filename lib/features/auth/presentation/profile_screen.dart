import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/auth/domain/user.dart';

import 'package:fiyatatlas/features/market/presentation/badges_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AppState>().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Profilinizi görmek için giriş yapmalısınız.'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AppState>().loginAnonymously();
                },
                icon: const Icon(Icons.login),
                label: const Text('Misafir Girişi Yap'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppState>().signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profil Başlığı
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showEditProfileDialog(context, user),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: NetworkImage(user.avatarUrl), 
                          child: user.avatarUrl.isEmpty 
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _showEditProfileDialog(context, user),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                  Text(
                    user.rank,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // İstatistikler Kartı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Puan', '${user.points}', Colors.orange),
                      _buildVerticalDivider(),
                      _buildStatItem('Katkı', '${user.entryCount}', Colors.blue),
                      _buildVerticalDivider(),
                      _buildStatItem('Sıralama', '#156', Colors.green),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Menü Listesi
            _buildMenuItem(
              context, 
              icon: Icons.history, 
              title: 'Fiyat Geçmişim', 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const _UserHistoryScreen()),
                );
              },
            ),
            _buildMenuItem(context, icon: Icons.favorite_border, title: 'Favori Listelerim', onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yakında eklenecek!')));
            }),
            _buildMenuItem(context, icon: Icons.badge_outlined, title: 'Rozetlerim', onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => const BadgesScreen()),
               );
            }),
            _buildMenuItem(context, icon: Icons.notifications_none, title: 'Bildirimler', onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bildiriminiz yok.')));
            }),
            _buildMenuItem(context, icon: Icons.help_outline, title: 'Yardım & Destek', onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('support@fiyatatlas.com')));
            }),
            
            const Divider(),
            
            _buildMenuItem(
              context, 
              icon: Icons.logout, 
              title: 'Çıkış Yap', 
              color: Colors.red, 
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Çıkış yapıldı (Simülasyon).')));
              },
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required IconData icon,
    required String title,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final avatarController = TextEditingController(text: user.avatarUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profili Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: avatarController,
              decoration: const InputDecoration(
                labelText: 'Profil Resmi URL',
                prefixIcon: Icon(Icons.image),
                helperText: 'Geçerli bir resim linki girin',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<AppState>().updateUser(
                  name: nameController.text,
                  avatarUrl: avatarController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil güncellendi.')),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _UserHistoryScreen extends StatelessWidget {
  const _UserHistoryScreen();

  @override
  Widget build(BuildContext context) {
    // Tüm entryleri al, kullanıcıya ait olduğu varsayılıyor (Mock data)
    final allEntries = context.watch<AppState>().entries;
    // Tersten sırala (En yeni en üstte)
    final entries = allEntries.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Fiyat Geçmişim')),
      body: entries.isEmpty 
          ? const Center(child: Text('Henüz veri girmediniz.'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                // Ürün adını AppState'den bul
                final appState = context.read<AppState>();
                String productName = 'Bilinmeyen Ürün';
                try {
                  final prod = appState.products.firstWhere((p) => p.barcode == entry.barcode);
                  productName = prod.name;
                } catch (_) {}

                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.blue),
                  title: Text(productName),
                  subtitle: Text('${entry.price} ₺ - ${entry.marketBranchId}'),
                  trailing: Text(
                    '${entry.entryDate.day}/${entry.entryDate.month}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/product-detail', arguments: entry.barcode);
                  },
                );
              },
            ),
    );
  }
}
