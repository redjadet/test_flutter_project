import 'package:complex_ui/core/ui/chart_config.dart';
import 'package:complex_ui/core/ui/layout.dart';
import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Short label extractor for bottom axis from a legend string.
String shortLabel(String legend) => legend.split(' ').first;

// Build FlTitlesData for bar charts with configurable styles and spacing.
FlTitlesData buildBarTitles({
  required int itemCount,
  required String Function(int index) labelForIndex,
  TextStyle leftStyle = axisLabelSmall,
  TextStyle bottomStyle = axisLabelTiny,
  double leftReservedSize = 28,
  double leftInterval = 10,
}) {
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: leftReservedSize,
        interval: leftInterval,
        getTitlesWidget: (value, meta) =>
            Text(value.toInt().toString(), style: leftStyle),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final i = value.toInt();
          if (i < 0 || i >= itemCount) return const SizedBox.shrink();
          final label = labelForIndex(i);
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: bottomStyle,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    ),
  );
}

// Build bar groups from PieSlice data (value/color reused for bar height and color).
List<BarChartGroupData> buildBarGroups(
  List<PieSlice> data, {
  double barWidth = 8,
}) {
  return [
    for (int i = 0; i < data.length; i++)
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i].value,
            color: data[i].color,
            width: barWidth,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
  ];
}

// Build full BarChartData from slices using shared defaults and helpers.
BarChartData buildBarChartData(
  List<PieSlice> data, {
  double barWidth = barWidthCard,
  double leftReservedSize = barLeftReservedSizeSmall,
  double leftInterval = barLeftInterval,
  TextStyle leftStyle = axisLabelSmall,
  TextStyle bottomStyle = axisLabelTiny,
  BarChartAlignment alignment = defaultBarAlignment,
}) {
  return BarChartData(
    gridData: const FlGridData(show: false),
    borderData: FlBorderData(show: false),
    alignment: alignment,
    titlesData: buildBarTitles(
      itemCount: data.length,
      labelForIndex: (i) => shortLabel(data[i].legend),
      leftReservedSize: leftReservedSize,
      leftInterval: leftInterval,
      leftStyle: leftStyle,
      bottomStyle: bottomStyle,
    ),
    barGroups: buildBarGroups(data, barWidth: barWidth),
  );
}
