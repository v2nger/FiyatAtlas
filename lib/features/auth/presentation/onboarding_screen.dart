import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Since shared_preferences was removed and we switched to Riverpod, we assume onboarding is handled elsewhere
    // or not required right now.
    // Just navigate to Login.
    
    // Auto-navigate
    Future.microtask(() {
      if (context.mounted) {
         Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
