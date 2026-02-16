import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/shared_providers.dart';
import 'features/price_log/data/models/price_log_model.dart';
import 'features/price_log/data/sync/sync_manager.dart';
import 'features/price_log/presentation/providers/submit_price_log_provider.dart';
import 'firebase_options.dart';

// ================= SYNC =================

final syncManagerProvider = Provider<PriceLogSyncManager>((ref) {
  return PriceLogSyncManager(
    localDataSource: ref.watch(priceLogLocalDataSourceProvider),
    remoteDataSource: ref.watch(priceLogRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// ================= AUTH =================

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// ================= MAIN =================

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase Initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Path Logic for Isar
    late final String path;
    if (kIsWeb) {
      path = "";
    } else {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }
    
    debugPrint('Isar Path: $path');
    debugPrint('Is Web: $kIsWeb');

    // Isar Initialization
    final isar = await Isar.open(
      [PriceLogModelSchema],
      directory: path,
    );

    final container = ProviderContainer(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
    );

    // Initialize Sync Manager (Fire-and-forget, but inside a microtask)
    Future.microtask(() {
      try {
        container.read(syncManagerProvider).init();
      } catch (e) {
        debugPrint('SyncManager Init Error: $e');
      }
    });

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const FiyatAtlasApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint('Initialization Error: $e\n$stack');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization Error: $e'),
          ),
        ),
      ),
    );
  }
}
