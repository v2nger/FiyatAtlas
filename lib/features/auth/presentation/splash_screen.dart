import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    // Show splash for at least 2 seconds
    final minWait = Future.delayed(const Duration(seconds: 2));

    // Wait for auth to be determined
    // This will wait for Firebase Auth -> Firestore User fetch
    final authFuture = ref.read(currentUserProvider.future);

    try {
      // Wait for both tasks to complete
      final results = await Future.wait([minWait, authFuture]);

      if (!mounted) return;

      final user = results[1] as dynamic; // Get the user object from results

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint('Splash Flow Error: $e');
      if (!mounted) return;
      // Navigate to login on error (or show error screen)
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using placeholder logic for logo
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
