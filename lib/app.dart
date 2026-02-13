import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_state.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/main_screen.dart';
import 'features/market/presentation/map_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/price/presentation/price_entry_screen.dart';
import 'features/product/presentation/product_detail_screen.dart';
import 'features/product/presentation/scan_screen.dart';
import 'features/product/presentation/search_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/verification/presentation/verification_screen.dart';

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
