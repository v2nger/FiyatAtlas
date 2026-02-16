import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .orderBy("trust_score", descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, index) {

              final data = docs[index].data() as Map<String, dynamic>;
              final tier = data["reputation_tier_current"] ?? "Bronze";

              final Color tierColor =
                  tier == "Atlas" ? Colors.amber :
                  tier == "Gold" ? Colors.orange :
                  tier == "Silver" ? Colors.grey :
                  Colors.brown;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: tierColor,
                  child: Text("${index + 1}"),
                ),
                title: Text(docs[index].id),
                subtitle: Text(
                  "Trust: ${data["trust_score"]} | Tier: $tier",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
