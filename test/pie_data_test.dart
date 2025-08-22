import 'package:complex_ui_openai/features/dashboard/data/pie_data.dart' as pie;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildPieSections returns one section per slice', () {
    final sections = pie.buildPieSections(radius: 42, showTitles: true);
    expect(sections.length, pie.kPieSlices.length);
  });

  test('pie titles appear only when provided', () {
    final sections = pie.buildPieSections(radius: 10, showTitles: true);
    // First three slices have titles in kPieSlices.
    expect(sections[0].title, isNotEmpty);
    expect(sections[1].title, isNotEmpty);
    expect(sections[2].title, isNotEmpty);
    // Others should be empty titles.
    for (var i = 3; i < sections.length; i++) {
      expect(sections[i].title, isEmpty);
    }
  });
}
