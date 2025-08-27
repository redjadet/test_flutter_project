import 'package:complex_ui/features/dashboard/state/data_generators.dart';
import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:complex_ui/features/dashboard/state/persistence_repo.dart';
import 'package:complex_ui/features/dashboard/state/token_distribution_repo.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  static const Duration _initialLoadDelay = Duration(milliseconds: 600);
  static const Duration _refreshDelay = Duration(milliseconds: 500);
  static const String _defaultUserName = 'User';
  static const String _defaultLocaleCode = 'en';

  DashboardState _state = const DashboardState();
  DashboardState get state => _state;

  void _emit(DashboardState next) {
    _state = next;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _emit(_state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final saved = await loadDashboardState();
      if (saved != null) {
        _emit(saved.copyWith(isLoading: false, isRefreshing: false));
        _fireAndForget(_maybeLoadAvaxDistribution(updateTitle: false));
      } else {
        await Future.delayed(_initialLoadDelay);
        final metrics = generateRandomMetrics();
        final charts = generateRandomCharts();
        _emit(
          _state.copyWith(metrics: metrics, charts: charts, isLoading: false),
        );
        await saveDashboardState(_state);
        await _maybeLoadAvaxDistribution();
      }
    } catch (e) {
      _emit(_state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> refreshData() async {
    _emit(_state.copyWith(isRefreshing: true));
    try {
      await Future.delayed(_refreshDelay);
      final metrics = generateRandomMetrics();
      final charts = generateRandomCharts();
      _emit(
        _state.copyWith(metrics: metrics, charts: charts, isRefreshing: false),
      );
      await saveDashboardState(_state);
      await _maybeLoadAvaxDistribution();
    } catch (e) {
      _emit(_state.copyWith(isRefreshing: false, errorMessage: e.toString()));
    }
  }

  void toggleChartExpansion(String chartId) {
    final updatedCharts = _state.charts.map((chart) {
      if (chart.id == chartId) {
        return chart.copyWith(isExpanded: !chart.isExpanded);
      }
      return chart;
    }).toList();
    _emit(_state.copyWith(charts: updatedCharts));
    _fireAndForget(saveDashboardState(_state));
  }

  void updateUserName(String name) {
    _emit(_state.copyWith(userName: name));
    _fireAndForget(saveDashboardState(_state));
  }

  void updateThemeMode(ThemeMode mode) {
    _emit(_state.copyWith(themeMode: mode));
    _fireAndForget(saveDashboardState(_state));
  }

  void updateLocale(String code) {
    _emit(_state.copyWith(localeCode: code));
    _fireAndForget(saveDashboardState(_state));
  }

  void toggleTheme(Brightness platformBrightness) {
    final nextMode = _calculateNextThemeMode(platformBrightness);
    updateThemeMode(nextMode);
  }

  ThemeMode _calculateNextThemeMode(Brightness platformBrightness) {
    final current = _state.themeMode;
    if (current == ThemeMode.system) {
      return platformBrightness == Brightness.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    } else {
      return current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
  }

  void clearError() {
    _emit(_state.copyWith(errorMessage: ''));
    _fireAndForget(saveDashboardState(_state));
  }

  Future<void> _maybeLoadAvaxDistribution({bool updateTitle = true}) async {
    final slices = await TokenDistributionRepo.fetchAvaxDistribution();
    if (slices == null || slices.isEmpty) return;
    final charts = _state.charts.toList();
    if (charts.isEmpty) return;
    final first = charts.first;
    charts[0] = first.copyWith(
      title: updateTitle ? 'AVAX Token Allocation' : first.title,
      data: slices,
    );
    _emit(_state.copyWith(charts: charts));
    await saveDashboardState(_state);
  }

  void resetSettings() {
    _emit(
      _state.copyWith(
        userName: _defaultUserName,
        themeMode: ThemeMode.system,
        localeCode: _defaultLocaleCode,
      ),
    );
    _fireAndForget(saveDashboardState(_state));
  }

  Future<void> _fireAndForget(Future<void> future) async {
    try {
      await future;
    } catch (_) {}
  }
}
