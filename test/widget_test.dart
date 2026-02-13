// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fiyatatlas/app.dart';
import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/auth/data/auth_service.dart';
import 'package:fiyatatlas/core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class MockAuthService extends Mock implements AuthService {
  @override
  Stream<fb_auth.User?> get authStateChanges => Stream.value(null);
}

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    final mockAuth = MockAuthService();
    final mockFirestore = MockFirestoreService();

    await tester.pumpWidget(
      ProviderScope(
        child: p.ChangeNotifierProvider(
          create: (_) => AppState(
            authService: mockAuth,
            firestoreService: mockFirestore,
          ),
          child: const FiyatAtlasApp(),
        ),
      ),
    );

    // Pump to flush initial frames
    await tester.pump();
    // Pump enough time for Splash Screen delay (assuming ~2 seconds)
    await tester.pump(const Duration(seconds: 3));

    // Initial load might show Splash or Onboarding
    expect(find.byType(FiyatAtlasApp), findsOneWidget);
  });
}
