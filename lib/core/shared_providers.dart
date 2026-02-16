import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';

import 'network/network_info.dart';
import 'services/firestore_service.dart';

// Check main.dart for Isar initialization and override
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError("Isar not available on Web");
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final internetCheckerProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker.createInstance();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(internetCheckerProvider));
});

