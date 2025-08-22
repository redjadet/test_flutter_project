import 'package:complex_ui_openai/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieSlice {
  final double value;
  final Color color;
  final String? title; // e.g., '50%'
  final String legend; // e.g., 'Staking – 50%'
  const PieSlice({
    required this.value,
    required this.color,
    this.title,
    required this.legend,
  });

  Map<String, dynamic> toMap() => {
    'value': value,
    'color': color.toARGB32(),
    'title': title,
    'legend': legend,
  };

  factory PieSlice.fromMap(Map<String, dynamic> map) => PieSlice(
    value: (map['value'] as num).toDouble(),
    color: Color((map['color'] as num).toInt()),
    title: map['title'] as String?,
    legend: map['legend'] as String,
  );
}

// Canonical dataset used by both dashboard and detail views.
const List<PieSlice> kPieSlices = [
  PieSlice(
    value: 50,
    color: AppColors.tealMedium,
    title: '50%',
    legend: 'Staking – 50%',
  ),
  PieSlice(
    value: 10,
    color: AppColors.blue,
    title: '10%',
    legend: 'Public Sale – 10%',
  ),
  PieSlice(
    value: 10,
    color: AppColors.orangeAccent,
    title: '10%',
    legend: 'Team – 10%',
  ),
  // Replace the dashboard's green slice with a red shade for consistency
  PieSlice(value: 9.26, color: AppColors.redDark, legend: 'Foundation – 9.26%'),
  PieSlice(value: 7, color: AppColors.purple, legend: 'Community – 7%'),
  PieSlice(value: 5, color: AppColors.red, legend: 'Partners – 5%'),
  PieSlice(value: 3.5, color: AppColors.indigo, legend: 'Private Sale – 3.5%'),
  PieSlice(value: 2.5, color: AppColors.yellow, legend: 'Seed Sale – 2.5%'),
  PieSlice(value: 2.5, color: AppColors.pink, legend: 'Airdrops – 2.5%'),
  PieSlice(value: 0.27, color: AppColors.grey, legend: 'Testnet – 0.27%'),
];

// Build sections from the canonical dataset.
List<PieChartSectionData> buildPieSections({
  double radius = 80,
  double sectionsSpace = 1,
  bool showTitles = true,
}) {
  return [
    for (final s in kPieSlices)
      PieChartSectionData(
        value: s.value,
        color: s.color,
        radius: radius,
        title: showTitles ? (s.title ?? '') : '',
        titleStyle: showTitles && s.title != null
            ? const TextStyle(color: Colors.white)
            : null,
      ),
  ];
}

// Build sections from an arbitrary data list (used by detail screens to reflect refreshed state).
List<PieChartSectionData> buildPieSectionsFrom(
  List<PieSlice> data, {
  double radius = 80,
  double sectionsSpace = 1,
  bool showTitles = true,
}) {
  return [
    for (final s in data)
      PieChartSectionData(
        value: s.value,
        color: s.color,
        radius: radius,
        title: showTitles ? (s.title ?? '') : '',
        titleStyle: showTitles && s.title != null
            ? const TextStyle(color: Colors.white)
            : null,
      ),
  ];
}
