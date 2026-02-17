import 'package:flutter/material.dart';

class GodBadge extends StatelessWidget {
  const GodBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Chip(
      backgroundColor: Colors.purple,
      label: Text(
        "GOD MODE",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
