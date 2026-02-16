// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/admin_providers.dart';

class UserManagementView extends ConsumerWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(allUsersStreamProvider);
    final userManager = ref.read(userManagementServiceProvider);

    return stream.when(
      data: (users) {
        if (users.isEmpty) return const Center(child: Text("No users found"));

        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final user = users[index];
            final uid = user['id'];
            final shadowBanned = user['shadow_banned'] ?? false;
            final trustScore = user['trust_score'] ?? 50;
            final deviceAbuse = user['device_abuse_count'] ?? 0;

            return ListTile(
              title: Text(user['name'] ?? 'Unknown User', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user['email'] ?? 'No Email'),
              leading: CircleAvatar(
                backgroundColor: shadowBanned ? Colors.grey : Colors.teal,
                child: Icon(shadowBanned ? Icons.block : Icons.check, color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Trust: $trustScore', style: TextStyle(color: _getTrustColor(trustScore))),
                      if (deviceAbuse > 0)
                        Text('Abuse: $deviceAbuse', style: TextStyle(color: Colors.redAccent, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: shadowBanned,
                    activeThumbColor: Colors.red,
                    onChanged: (val) {
                      userManager.toggleShadowBan(uid, shadowBanned);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Color _getTrustColor(int score) {
    if (score > 80) return Colors.greenAccent;
    if (score > 50) return Colors.amber;
    return Colors.red;
  }
}
