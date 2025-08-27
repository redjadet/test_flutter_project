import 'package:complex_ui/core/config/flavor.dart';
import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/dashboard/screens/dashboard_screen.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/profile/profile.dart';
import 'package:complex_ui/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class ComplexApp extends StatelessWidget {
  const ComplexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select(
      (DashboardController c) => c.state.themeMode,
    );
    final localeCode = context.select(
      (DashboardController c) => c.state.localeCode,
    );
    const colorSeed = Color(0xFF00897B); // AppColors.tealMedium

    final darkScheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: Brightness.dark,
    );

    return Consumer<NavigationService>(
      builder: (context, navigationService, child) {
        final flavor = FlavorConfig.instance.flavor;
        final suffix = switch (flavor) {
          AppFlavor.dev => ' (DEV)',
          AppFlavor.test => ' (TEST)',
          AppFlavor.prod => '',
        };

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Complex UI $suffix',
          navigatorKey: navigationService.navigatorKey,
          scaffoldMessengerKey: navigationService.scaffoldMessengerKey,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themeMode,
          locale: Locale(localeCode),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
            scaffoldBackgroundColor: const Color(0xFFF7F7F9),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme.copyWith(surface: const Color(0xFF111316)),
            scaffoldBackgroundColor: const Color(0xFF0D0F12),
            cardTheme: const CardThemeData(color: Color(0xFF15181D)),
            dividerColor: Colors.white24,
            useMaterial3: true,
            textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xFF15181D),
              foregroundColor: Colors.white,
            ),
          ),
          home: const MainNavigation(),
          routes: {
            '/profile': (context) => const ProfileScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}
