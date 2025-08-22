import 'dart:convert';
import 'dart:io';

import 'package:complex_ui_openai/features/dashboard/state/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Simple file-based persistence without extra packages.
// For desktop/mobile dev, writes to a .app_state folder in CWD.
// For web (kIsWeb), persistence is skipped gracefully.

const _appFolder = 'complex_ui_openai';
const _prefsFile = 'dashboard_prefs.json';
const _metricsFile = 'metrics.json';
const _chartsFile = 'charts.json';

Future<void> saveDashboardState(DashboardState state) async {
  if (kIsWeb) return; // No file system on web in this minimal impl
  try {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/$_appFolder');
    if (!await dir.exists()) await dir.create(recursive: true);

    // Prepare sectioned payloads
    final prefs = {
      'userName': state.userName,
      'themeMode': state.themeMode.name,
      'localeCode': state.localeCode,
    };
    final metrics = [for (final m in state.metrics) m.toMap()];
    final charts = [for (final c in state.charts) c.toMap()];

    await _writeIfChanged(File('${dir.path}/$_prefsFile'), prefs);
    await _writeIfChanged(File('${dir.path}/$_metricsFile'), metrics);
    await _writeIfChanged(File('${dir.path}/$_chartsFile'), charts);
  } catch (_) {
    // Swallow errors to avoid disrupting UX.
  }
}

Future<DashboardState?> loadDashboardState() async {
  if (kIsWeb) return null;
  try {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/$_appFolder');

    // Read sections if present
    final prefs = await _readIfExists(File('${dir.path}/$_prefsFile'));
    final metrics = await _readIfExists(File('${dir.path}/$_metricsFile'));
    final charts = await _readIfExists(File('${dir.path}/$_chartsFile'));

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
      themeMode: (prefs is Map && prefs['themeMode'] is String)
          ? (prefs['themeMode'] == 'dark'
                ? ThemeMode.dark
                : prefs['themeMode'] == 'light'
                ? ThemeMode.light
                : ThemeMode.system)
          : ThemeMode.system,
      localeCode: (prefs is Map && prefs['localeCode'] is String)
          ? prefs['localeCode'] as String
          : 'en',
    );
  } catch (_) {
    return null;
  }
}

Future<void> _writeIfChanged(File file, Object jsonObj) async {
  final newStr = jsonEncode(jsonObj);
  if (await file.exists()) {
    try {
      final oldStr = await file.readAsString();
      if (oldStr == newStr) return; // skip write if identical
    } catch (_) {}
  }
  await file.writeAsString(newStr);
}

Future<Object?> _readIfExists(File file) async {
  try {
    if (!await file.exists()) return null;
    final str = await file.readAsString();
    return jsonDecode(str);
  } catch (_) {
    return null;
  }
}
