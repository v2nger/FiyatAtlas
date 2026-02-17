import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State for invisible mode
final invisibleModeProvider = StateProvider<bool>((ref) => false);

// Stats provider
final godStatsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return FirebaseFirestore.instance
      .collection('sys_stats')
      .doc('main')
      .snapshots()
      .map((snapshot) => snapshot.data() ?? {});
});

// Pending products provider
final pendingProductsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('status', isEqualTo: 'pending')
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
});
