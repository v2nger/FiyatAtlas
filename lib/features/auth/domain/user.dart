import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int points;
  final String rank;
  final int entryCount;
  final DateTime joinDate;
  final List<String> earnedBadgeIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.points = 0,
    this.rank = 'Gezgin',
    this.entryCount = 0,
    required this.joinDate,
    this.earnedBadgeIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'points': points,
      'rank': rank,
      'entryCount': entryCount,
      'joinDate': Timestamp.fromDate(joinDate),
      'earnedBadgeIds': earnedBadgeIds,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? 'https://i.pravatar.cc/300?img=12',
      points: data['points'] ?? 0,
      rank: data['rank'] ?? 'Gezgin',
      entryCount: data['entryCount'] ?? 0,
      joinDate: (data['joinDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      earnedBadgeIds: List<String>.from(data['earnedBadgeIds'] ?? []),
    );
  }
}
