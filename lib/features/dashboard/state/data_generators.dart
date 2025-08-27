import 'dart:math' as math;

import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:flutter/material.dart';

// Random metric generation used by dashboard demos
List<MetricData> generateRandomMetrics() {
  final rnd = math.Random();

  double randRange(double min, double max) =>
      min + rnd.nextDouble() * (max - min);
  double posPercent() => double.parse(randRange(5, 95).toStringAsFixed(1));

  final totalRevenue = (randRange(50_000, 250_000)).roundToDouble();
  final activeUsers = (randRange(5_000, 60_000)).roundToDouble();
  final conversionRate = double.parse(randRange(1.0, 7.5).toStringAsFixed(1));
  final churnRate = double.parse(randRange(0.5, 5.0).toStringAsFixed(1));

  return [
    MetricData(
      id: 'metric_1',
      title: 'Total Revenue',
      value: totalRevenue,
      unit: '\$',
      description: 'Monthly revenue performance',
      icon: Icons.trending_up,
      percentage: posPercent(),
      isPositive: true,
    ),
    MetricData(
      id: 'metric_2',
      title: 'Active Users',
      value: activeUsers,
      unit: '',
      description: 'Daily active users',
      icon: Icons.people,
      percentage: posPercent(),
      isPositive: true,
    ),
    MetricData(
      id: 'metric_3',
      title: 'Conversion Rate',
      value: conversionRate,
      unit: '%',
      description: 'Lead to customer conversion',
      icon: Icons.analytics,
      percentage: posPercent(),
      isPositive: rnd.nextBool(),
    ),
    MetricData(
      id: 'metric_4',
      title: 'Churn Rate',
      value: churnRate,
      unit: '%',
      description: 'Monthly customer churn',
      icon: Icons.trending_down,
      percentage: posPercent(),
      isPositive: !rnd.nextBool(),
    ),
  ];
}

// Use template for colors and labels, but randomize values summing ~100.
List<PieSlice> randomizeSlicesTemplate() {
  final rnd = math.Random();
  const template = kPieSlices;

  final raw = [
    for (int i = 0; i < template.length; i++) rnd.nextDouble() + 0.05,
  ];
  final sum = raw.fold<double>(0, (a, b) => a + b);
  final values = raw.map((v) => (v / sum) * 100.0).toList();

  return [
    for (int i = 0; i < template.length; i++)
      PieSlice(
        value: double.parse(values[i].toStringAsFixed(2)),
        color: template[i].color,
        title: '${values[i].toStringAsFixed(0)}%',
        legend: updateLegendPercent(template[i].legend, values[i]),
      ),
  ];
}

String updateLegendPercent(String legend, double value) {
  final dashIdx = legend.indexOf('–');
  final base = dashIdx != -1 ? legend.substring(0, dashIdx).trim() : legend;
  return '$base – ${value.toStringAsFixed(1)}%';
}

List<ChartData> generateRandomCharts() {
  return [
    ChartData(
      id: 'chart_1',
      title: 'Revenue Distribution',
      data: randomizeSlicesTemplate(),
      type: ChartType.bar,
    ),
    ChartData(
      id: 'chart_2',
      title: 'User Growth',
      data: randomizeSlicesTemplate(),
      type: ChartType.bar,
    ),
    ChartData(
      id: 'chart_3',
      title: 'Market Share',
      data: randomizeSlicesTemplate(),
      type: ChartType.bar,
    ),
    ChartData(
      id: 'chart_4',
      title: 'Performance Metrics',
      data: randomizeSlicesTemplate(),
      type: ChartType.bar,
    ),
  ];
}
