import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fiyatatlas/app_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFlow();
    });
  }

  Future<void> _checkFlow() async {
    // Biraz bekle (Logo görünsün)
    await Future.delayed(const Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenOnboarding') ?? false;

    if (!mounted) return;

    // Check Auth State from Provider
    final appState = context.read<AppState>();
    
    // If logged in -> Home
    if (appState.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    // Not logged in -> Onboarding (if not seen) or Login
    if (seen) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arkaplan Resmi (Logo)
          // "İkiyana yaslayıp arkaplanda duvarkağıdı olarak"
          Opacity(
            opacity: 0.1, // Hafif silik görünmesi için
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover, // Ekranı kaplaması için
            ),
          ),
          // Ortada Logoyu net göstermek istersek (Opsiyonel ama şık durur)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 // Logonun orijinal hali ortada
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fitWidth, 
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
