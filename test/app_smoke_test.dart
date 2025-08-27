import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_grid.dart';
import 'package:complex_ui/features/dashboard/widgets/metric_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('MetricList renders without errors', (tester) async {
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
            home: Scaffold(body: MetricList()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.byType(MetricList), findsOneWidget);
    });

    testWidgets('ChartGrid renders without errors', (tester) async {
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
            home: Scaffold(body: ChartGrid()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.byType(ChartGrid), findsOneWidget);
    });

    testWidgets('Widgets handle empty state gracefully', (tester) async {
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
            home: Scaffold(body: Column(children: [MetricList(), ChartGrid()])),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should render both widgets without errors
      expect(find.byType(MetricList), findsOneWidget);
      expect(find.byType(ChartGrid), findsOneWidget);
    });
  });
}
