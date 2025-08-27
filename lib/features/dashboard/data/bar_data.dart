import 'package:complex_ui/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<BarChartGroupData> buildBarGroups({
  required int index,
  int count = 5,
  double factor = 5.0,
  Color color = AppColors.tealMedium,
}) {
  return [
    for (int x = 0; x < count; x++)
      BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(toY: (index + 1) * (x + 1) * factor, color: color),
        ],
      ),
  ];
}
