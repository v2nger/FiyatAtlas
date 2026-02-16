import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int points;
  final String rank;
  final int entryCount;
  final String role;
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
    this.role = 'user',
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
      'role': role,
      'joinDate': Timestamp.fromDate(joinDate),
      'earnedBadgeIds': earnedBadgeIds,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    int? points,
    String? rank,
    int? entryCount,
    String? role,
    DateTime? joinDate,
    List<String>? earnedBadgeIds,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      entryCount: entryCount ?? this.entryCount,
      role: role ?? this.role,
      joinDate: joinDate ?? this.joinDate,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
    );
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
      role: data['role'] ?? 'user',
      joinDate: (data['joinDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      earnedBadgeIds: List<String>.from(data['earnedBadgeIds'] ?? []),
    );
  }
}
