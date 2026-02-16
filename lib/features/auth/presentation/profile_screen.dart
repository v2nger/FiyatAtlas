import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../market/presentation/badges_screen.dart';
import '../../price_log/presentation/providers/submit_price_log_provider.dart';
import '../domain/user.dart';
import 'providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
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
                      ref.read(authControllerProvider).signInAnonymously();
                      // Or navigate to login screen if that's better
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
                  ref.read(authControllerProvider).signOut();
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Çıkış Yap',
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
                        onTap: () => _showEditProfileDialog(context, ref, user),
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
                        onTap: () => _showEditProfileDialog(context, ref, user),
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
                          _buildStatItem('Sıralama', '#TODO', Colors.green),
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
                _buildMenuItem(
                  context, 
                  icon: Icons.verified, 
                  title: 'Rozetlerim', 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BadgesScreen()), 
                    );
                  },
                ),
                _buildMenuItem(
                  context, 
                  icon: Icons.settings, 
                  title: 'Ayarlar', 
                  onTap: () {
                    // Ayarlar Sayfası (Mock placeholder)
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text("Hata: $e"))),
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
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, User user) {
    final nameController = TextEditingController(text: user.name);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profili Düzenle'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Ad Soyad',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                 ref.read(currentUserProvider.notifier).updateProfile(name: newName);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _UserHistoryScreen extends ConsumerWidget {
  const _UserHistoryScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(userPriceLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Fiyat Geçmişim")),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
             return const Center(child: Text("Henüz fiyat girişi yok."));
          }
           return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
               final entry = logs[index];
               return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text("${entry.price} ₺"),
                  subtitle: Text("Market: ${entry.marketId}\nBarkod: ${entry.productId}"),
                  isThreeLine: true,
               );
            }
           );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Hata: $e")),
      ),
    );
  }
}
