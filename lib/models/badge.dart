import 'package:flutter/material.dart';

class UserBadge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final Color color;

  const UserBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
  });
}
