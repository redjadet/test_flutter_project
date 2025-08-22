import 'package:complex_ui_openai/core/mvp/presenter.dart';
import 'package:complex_ui_openai/core/services/navigation_service.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui_openai/features/dashboard/state/models.dart';
import 'package:complex_ui_openai/features/dashboard/state/persistence_repo.dart';
import 'package:flutter/material.dart';

abstract class SettingsView {}

abstract class ISettingsPresenter {
  void updateUserName(String name);
  void updateThemeMode(ThemeMode mode);
  void updateLocale(String code);
  Future<PersistenceBackend> currentBackend();
  Future<void> switchBackend(PersistenceBackend backend, DashboardState state);
  Future<void> resetToDefaults();
  void onSavePressed(String name);
  void onBackPressed();
  bool isNameValid(String name);
}

class SettingsPresenter extends Presenter<SettingsView>
    implements ISettingsPresenter {
  static const int _minNameLength = 2;

  final DashboardController _controller;
  final INavigationService _navigationService;

  SettingsPresenter(this._controller, this._navigationService);

  @override
  void updateUserName(String name) => _controller.updateUserName(name);

  @override
  void updateThemeMode(ThemeMode mode) => _controller.updateThemeMode(mode);

  @override
  void updateLocale(String code) => _controller.updateLocale(code);

  @override
  Future<PersistenceBackend> currentBackend() => PersistenceRepo.current();

  @override
  Future<void> switchBackend(
    PersistenceBackend backend,
    DashboardState state,
  ) async {
    await PersistenceRepo.setBackend(backend);
    await saveDashboardState(state);
  }

  @override
  Future<void> resetToDefaults() async {
    await PersistenceRepo.setBackend(PersistenceBackend.file);
    _controller.resetSettings();
  }

  @override
  void onSavePressed(String name) {
    final trimmedName = name.trim();
    if (!isNameValid(trimmedName)) {
      _navigationService.showSnackBar(
        'Name must be at least $_minNameLength characters',
      );
      return;
    }

    updateUserName(trimmedName);
    _navigationService.showSnackBar('Settings saved successfully');
    _navigationService.navigateBack();
  }

  @override
  void onBackPressed() {
    _navigationService.navigateBack();
  }

  @override
  bool isNameValid(String name) => name.trim().length >= _minNameLength;
}
