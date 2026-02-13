import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'firebase_options.dart';

import 'app.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    riverpod.ProviderScope(
      child: ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const FiyatAtlasApp(),
      ),
    ),
  );
}
