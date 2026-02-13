import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_state.dart';
import 'screens/login_screen.dart'; // Add login screen import
import 'screens/main_screen.dart'; 
import 'screens/map_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/price_entry_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/search_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/verification_screen.dart';

class FiyatAtlasApp extends StatelessWidget {
  const FiyatAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to AppState to change locale dynamically
    final appState = context.watch<AppState>();

    // Google Fonts ile tema oluşturma
    final textTheme = GoogleFonts.poppinsTextTheme();
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

    return MaterialApp(
      title: 'FiyatAtlas',
      debugShowCheckedModeBanner: false,

      // Localization Configuration
      locale: appState.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],

      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: textTheme, // Font uygula
        scaffoldBackgroundColor: colorScheme.surface,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(), // Add login route
        '/home': (_) => const MainScreen(), 
        '/map': (_) => const MapScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/scan': (_) => const ScanScreen(),
        '/price-entry': (_) => const PriceEntryScreen(),
        '/search': (_) => const SearchScreen(),
        '/verification': (_) => const VerificationScreen(),
        '/product-detail': (_) => const ProductDetailScreen(),
      },
    );
  }
}
