import 'package:complex_ui_openai/features/dashboard/state/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _hiveBox = 'dashboard_box';

Future<void> _ensureHive() async {
  if (!kIsWeb) {
    // On mobile/desktop Hive.initFlutter handles directory selection.
  }
  if (!Hive.isAdapterRegistered(0)) {
    await Hive.initFlutter();
  }
}

Future<void> saveDashboardStateDb(DashboardState state) async {
  await _ensureHive();
  final box = await Hive.openBox(_hiveBox);

  final prefs = {
    'userName': state.userName,
    'themeMode': state.themeMode.name,
    'localeCode': state.localeCode,
  };
  final metrics = [for (final m in state.metrics) m.toMap()];
  final charts = [for (final c in state.charts) c.toMap()];

  // Only write if changed
  if (box.get('prefs') != prefs) await box.put('prefs', prefs);
  if (box.get('metrics') != metrics) await box.put('metrics', metrics);
  if (box.get('charts') != charts) await box.put('charts', charts);
}

Future<DashboardState?> loadDashboardStateDb() async {
  await _ensureHive();
  final box = await Hive.openBox(_hiveBox);

  final prefs = box.get('prefs');
  final metrics = box.get('metrics');
  final charts = box.get('charts');

  if (prefs == null && metrics == null && charts == null) return null;

  return DashboardState(
    metrics: [
      for (final m in (metrics as List? ?? const []))
        MetricData.fromMap(Map<String, dynamic>.from(m as Map)),
    ],
    charts: [
      for (final c in (charts as List? ?? const []))
        ChartData.fromMap(Map<String, dynamic>.from(c as Map)),
    ],
    isLoading: false,
    errorMessage: '',
    userName: (prefs is Map && prefs['userName'] is String)
        ? prefs['userName'] as String
        : 'User',
    isRefreshing: false,
    themeMode: (prefs is Map)
        ? _themeModeFromName(prefs['themeMode'] as String?)
        : ThemeMode.system,
    localeCode: (prefs is Map && prefs['localeCode'] is String)
        ? prefs['localeCode'] as String
        : 'en',
  );
}

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
