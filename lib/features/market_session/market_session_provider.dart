import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeMarketProvider = StreamProvider.autoDispose<Map<String, dynamic>?>((
  ref,
) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data()?["active_market"]);
});

class MarketSessionController {
  Future<void> enterMarket({
    required String marketId,
    required String marketName,
    required double lat,
    required double lng,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "active_market": {
        "market_id": marketId,
        "market_name": marketName,
        "lat": lat,
        "lng": lng,
        "started_at": FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
  }

  Future<void> exitMarket() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "active_market": FieldValue.delete(),
    });
  }
}

final marketSessionControllerProvider = Provider<MarketSessionController>((
  ref,
) {
  return MarketSessionController();
});
