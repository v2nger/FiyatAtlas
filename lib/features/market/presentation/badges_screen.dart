import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/market/domain/badge.dart';
import 'package:fiyatatlas/features/market/data/badges_data.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AppState>().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rozetler')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/'), 
            child: const Text('Profil Sayfasına Git'),
          ),
        ),
      );
    }

    final earnedIds = user.earnedBadgeIds;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rozet Koleksiyonu (${earnedIds.length}/${allBadges.length})'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75, 
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: allBadges.length,
        itemBuilder: (context, index) {
          final badge = allBadges[index];
          final isEarned = earnedIds.contains(badge.id);

          return _BadgeCard(badge: badge, isEarned: isEarned);
        },
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.isEarned});

  final UserBadge badge;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => _BadgeDetailDialog(badge: badge, isEarned: isEarned),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isEarned 
              ? LinearGradient(
                  colors: [
                    badge.color.withValues(alpha: 0.1),
                    badge.color.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade100, Colors.grey.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: isEarned 
              ? Border.all(color: badge.color.withValues(alpha: 0.6), width: 2)
              : Border.all(color: Colors.grey.shade300),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
              ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isEarned)
                   Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(color: badge.color.withValues(alpha: 0.6), blurRadius: 20, spreadRadius: 1)
                      ],
                    ),
                  ),
                isEarned
                    ? Text(badge.emoji, style: const TextStyle(fontSize: 40))
                    : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(badge.emoji, style: const TextStyle(fontSize: 40)),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isEarned ? Colors.black87 : Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isEarned)
              Padding(
                 padding: const EdgeInsets.only(top: 8),
                 child: Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade400), 
              ),
          ],
        ),
      ),
    );
  }
}

class _BadgeDetailDialog extends StatelessWidget {
  const _BadgeDetailDialog({required this.badge, required this.isEarned});

  final UserBadge badge;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEarned ? badge.color.withValues(alpha: 0.2) : Colors.grey.shade100,
              ),
              child: isEarned
                  ? Text(badge.emoji, style: const TextStyle(fontSize: 80))
                  : ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: Opacity(
                        opacity: 0.5,
                        child: Text(badge.emoji, style: const TextStyle(fontSize: 80)),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              badge.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (isEarned)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text('Kazanıldı', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text('Kilitli', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
             const SizedBox(height: 20),
             TextButton(
               onPressed: () => Navigator.pop(context),
               child: const Text('Kapat'),
             )
          ],
        ),
      ),
    );
  }
}
