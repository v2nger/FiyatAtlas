import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedPricesScreen extends StatelessWidget {
  const VerifiedPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verified Prices")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("verified_prices")
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

              final confidence = (data["confidence"] ?? 0).toDouble();
              final anomaly = (data["anomaly_score"] ?? 0).toDouble();
              final volatility = (data["volatility_index"] ?? 0).toDouble();

              final Color anomalyColor = anomaly > 0.8
                  ? Colors.red
                  : anomaly > 0.5
                  ? Colors.orange
                  : Colors.green;

              return Card(
                child: ListTile(
                  title: Text("${data["product_id"]} - ${data["market_id"]}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: ${data["verified_price"]}"),
                      Text("Confidence: ${confidence.toStringAsFixed(1)}%"),
                      Text(
                        "Anomaly: ${anomaly.toStringAsFixed(2)}",
                        style: TextStyle(color: anomalyColor),
                      ),
                      Text("Volatility: ${volatility.toStringAsFixed(3)}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
