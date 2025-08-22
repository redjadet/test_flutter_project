import 'package:complex_ui_openai/core/l10n/app_localizations.dart';
import 'package:complex_ui_openai/features/dashboard/screens/dashboard_screen.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui_openai/features/dashboard/widgets/chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Chart grid renders on narrow width', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(800, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DashboardController()),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Wrap-based layout: should render 4 ChartCard widgets.
    final cards = find.byType(ChartCard);
    expect(cards, findsNWidgets(4));
  });

  testWidgets('Chart grid renders on wide width', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DashboardController()),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cards = find.byType(ChartCard);
    expect(cards, findsNWidgets(4));
  });
}
