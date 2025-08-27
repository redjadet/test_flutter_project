import 'package:complex_ui/app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end: open chart detail', (tester) async {
    await tester.pumpWidget(const ComplexApp());
    await tester.pumpAndSettle();

    // Verify key sections render
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.textContaining('Welcome Back'), findsOneWidget);
    expect(find.text('Statistics'), findsOneWidget);

    // Tap the first chart (now BarChart) to open the detail bottom sheet
    final chartFinder = find.byType(BarChart).first;
    expect(chartFinder, findsOneWidget);
    await tester.tap(chartFinder);
    await tester.pumpAndSettle();

    // Detail sheet should appear for chart 1
    expect(find.textContaining('Chart 1 Detail'), findsOneWidget);
  });
}
