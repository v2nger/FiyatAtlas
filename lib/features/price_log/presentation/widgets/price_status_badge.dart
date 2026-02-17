import 'package:flutter/material.dart';

class PriceStatusBadge extends StatelessWidget {
  final String status;
  final int confidence;

  const PriceStatusBadge({
    super.key,
    required this.status,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case "verified":
        color = Colors.green;
        label = "Verified";
        break;
      case "pending":
        color = Colors.orange;
        label = "Pending";
        break;
      default:
        color = Colors.grey;
        label = "Private";
    }

    return Chip(
      backgroundColor: color.withValues(alpha: .15),
      shape: StadiumBorder(side: BorderSide(color: color)),
      label: Text(
        "$label • $confidence",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
