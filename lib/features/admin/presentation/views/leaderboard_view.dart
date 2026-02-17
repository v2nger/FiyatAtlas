// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/admin_providers.dart';

class LeaderboardView extends ConsumerWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(leaderboardStreamProvider);

    return stream.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index];
            final trustScore = (userData['trust_score'] as num?)?.toInt() ?? 50;
            final tier = userData['reputation_tier_current'] ?? 'Bronze';
            final name = userData['name'] ?? 'Anonymous';
            final avatarUrl = userData['avatar_url'];

            final isAtlas = tier == 'Atlas';

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isAtlas
                    ? [
                        BoxShadow(
                          color: Colors.amberAccent.withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null ? Text(name[0]) : null,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAtlas ? Colors.amber : null,
                  ),
                ),
                subtitle: Text('Score: $trustScore'),
                trailing: _TierBadge(tier: tier),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final String tier;
  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (tier) {
      case 'Atlas':
        color = Colors.amber;
        break;
      case 'Gold':
        color = Colors.yellow[700]!;
        break;
      case 'Silver':
        color = Colors.grey[400]!;
        break;
      default:
        color = Colors.brown[300]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        tier.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
