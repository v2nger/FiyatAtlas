import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/home/presentation/main_screen.dart';
import 'features/market/presentation/map_screen.dart';
import 'features/price/presentation/price_entry_screen.dart';
import 'features/product/presentation/scan_screen.dart';
import 'features/product/presentation/search_screen.dart';
import 'features/product/presentation/views/product_detail_screen.dart';
import 'features/verification/presentation/verification_screen.dart';
import 'l10n/app_localizations.dart';

class FiyatAtlasApp extends ConsumerWidget {
  const FiyatAtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to LocaleProvider
    final locale = ref.watch(localeNotifierProvider);

    // Uygulama koyu modda çalışacağı için default olarak AppTheme.darkTheme
    return MaterialApp(
      title: 'FiyatAtlas',
      debugShowCheckedModeBanner: false,

      // Localization Configuration
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],

      // THEME CONFIGURATION
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(), // Fallback unused
      darkTheme: AppTheme.darkTheme,

      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(), // Add login route
        '/home': (_) => const MainScreen(),
        '/map': (_) => const MapScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/scan': (_) => const ScanScreen(),
        '/search': (_) => const SearchScreen(),
        '/verification': (_) => const VerificationScreen(),
        '/product-detail': (_) => const ProductDetailScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/price-entry') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return PriceEntryScreen(
                product: args['product'],
                branch: args['branch'],
              );
            },
          );
        }
        return null; // Let the default route handler fail if not found
      },
    );
  }
}
