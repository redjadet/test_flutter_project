import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_provider.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChartCard displays BarChart and is tappable', (tester) async {
    const testChart = ChartData(
      id: 'test_chart',
      title: 'Test Chart',
      data: kPieSlices,
      type: ChartType.bar,
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(child: ChartCard(chart: testChart)),
        ),
      ),
    );

    // Verify BarChart is present
    expect(find.byType(BarChart), findsOneWidget);

    // Verify the chart is tappable
    await tester.tap(find.byType(BarChart));
    await tester.pumpAndSettle();

    // Verify the widget is still present after tap
    expect(find.byType(BarChart), findsOneWidget);
  });
}
