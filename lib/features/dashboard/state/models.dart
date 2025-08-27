import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:flutter/material.dart';

class DashboardState {
  final List<MetricData> metrics;
  final List<ChartData> charts;
  final bool isLoading;
  final String errorMessage;
  final String userName;
  final bool isRefreshing;
  final ThemeMode themeMode;
  final String localeCode; // e.g., 'en', 'tr'

  const DashboardState({
    this.metrics = const [],
    this.charts = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.userName = 'User',
    this.isRefreshing = false,
    this.themeMode = ThemeMode.system,
    this.localeCode = 'en',
  });

  DashboardState copyWith({
    List<MetricData>? metrics,
    List<ChartData>? charts,
    bool? isLoading,
    String? errorMessage,
    String? userName,
    bool? isRefreshing,
    ThemeMode? themeMode,
    String? localeCode,
  }) {
    return DashboardState(
      metrics: metrics ?? this.metrics,
      charts: charts ?? this.charts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userName: userName ?? this.userName,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  Map<String, dynamic> toMap() => {
    'metrics': [for (final m in metrics) m.toMap()],
    'charts': [for (final c in charts) c.toMap()],
    'isLoading': isLoading,
    'errorMessage': errorMessage,
    'userName': userName,
    'isRefreshing': isRefreshing,
    'themeMode': themeMode.name,
    'localeCode': localeCode,
  };

  factory DashboardState.fromMap(Map<String, dynamic> map) => DashboardState(
    metrics: [
      for (final m in (map['metrics'] as List? ?? const []))
        MetricData.fromMap(Map<String, dynamic>.from(m as Map)),
    ],
    charts: [
      for (final c in (map['charts'] as List? ?? const []))
        ChartData.fromMap(Map<String, dynamic>.from(c as Map)),
    ],
    isLoading: map['isLoading'] == true,
    errorMessage: (map['errorMessage'] as String?) ?? '',
    userName: (map['userName'] as String?) ?? 'User',
    isRefreshing: map['isRefreshing'] == true,
    themeMode: _themeModeFromName(map['themeMode'] as String?),
    localeCode: (map['localeCode'] as String?) ?? 'en',
  );
}

class MetricData {
  final String id;
  final String title;
  final double value;
  final String unit;
  final String description;
  final IconData icon;
  final double percentage;
  final bool isPositive;

  const MetricData({
    required this.id,
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.icon,
    required this.percentage,
    this.isPositive = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'value': value,
    'unit': unit,
    'description': description,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'percentage': percentage,
    'isPositive': isPositive,
  };

  factory MetricData.fromMap(Map<String, dynamic> map) => MetricData(
    id: map['id'] as String,
    title: map['title'] as String,
    value: (map['value'] as num).toDouble(),
    unit: (map['unit'] as String?) ?? '',
    description: (map['description'] as String?) ?? '',
    icon: IconData(
      (map['iconCodePoint'] as num).toInt(),
      fontFamily: map['iconFontFamily'] as String?,
      matchTextDirection: false,
    ),
    percentage: (map['percentage'] as num).toDouble(),
    isPositive: map['isPositive'] == true,
  );
}

class ChartData {
  final String id;
  final String title;
  final List<PieSlice> data;
  final ChartType type;
  final bool isExpanded;

  const ChartData({
    required this.id,
    required this.title,
    required this.data,
    required this.type,
    this.isExpanded = false,
  });

  ChartData copyWith({
    String? id,
    String? title,
    List<PieSlice>? data,
    ChartType? type,
    bool? isExpanded,
  }) {
    return ChartData(
      id: id ?? this.id,
      title: title ?? this.title,
      data: data ?? this.data,
      type: type ?? this.type,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'data': [for (final s in data) s.toMap()],
    'type': type.name,
    'isExpanded': isExpanded,
  };

  factory ChartData.fromMap(Map<String, dynamic> map) => ChartData(
    id: map['id'] as String,
    title: map['title'] as String,
    data: [
      for (final s in (map['data'] as List? ?? const []))
        PieSlice.fromMap(Map<String, dynamic>.from(s as Map)),
    ],
    type: _chartTypeFromName(map['type'] as String?),
    isExpanded: map['isExpanded'] == true,
  );
}

enum ChartType { bar, pie, line }

ThemeMode _themeModeFromName(String? name) {
  switch (name) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

ChartType _chartTypeFromName(String? name) {
  switch (name) {
    case 'pie':
      return ChartType.pie;
    case 'line':
      return ChartType.line;
    case 'bar':
    default:
      return ChartType.bar;
  }
}
