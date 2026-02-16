import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stream of real-time verified prices
final verifiedPricesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('verified_prices')
      .orderBy('verified_at', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

// Stream of Leaderboard (ordered by trust_score)
final leaderboardStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('trust_score', descending: true)
      .limit(20)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
});

// Stream of all users for Admin User Management
final allUsersStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('created_at', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
});

// Admin toggle ban function
final userManagementServiceProvider = Provider<UserManagementService>((ref) => UserManagementService());

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleShadowBan(String userId, bool currentValue) async {
    await _firestore.collection('users').doc(userId).update({
      'shadow_banned': !currentValue,
    });
  }
}
