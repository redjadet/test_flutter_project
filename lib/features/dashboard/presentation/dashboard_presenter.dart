import 'package:complex_ui/core/mvp/presenter.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/chat/screens/chat_list_screen.dart';
import 'package:complex_ui/features/dashboard/screens/settings_screen.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:flutter/material.dart';

abstract class DashboardView {
  void showThemeToggle();
}

abstract class IDashboardPresenter {
  Future<void> init();
  Future<void> refresh();
  void toggleTheme(Brightness platformBrightness);
  void clearError();
  void onSettingsPressed();
  void onChatPressed();
  void onThemeTogglePressed();
}

class DashboardPresenter extends Presenter<DashboardView>
    implements IDashboardPresenter {
  final DashboardController _controller;
  final INavigationService _navigationService;

  DashboardPresenter(this._controller, this._navigationService);

  @override
  Future<void> init() => _controller.loadDashboardData();

  @override
  Future<void> refresh() => _controller.refreshData();

  @override
  void toggleTheme(Brightness platformBrightness) =>
      _controller.toggleTheme(platformBrightness);

  @override
  void clearError() => _controller.clearError();

  @override
  void onSettingsPressed() {
    _navigationService.navigateTo(const SettingsScreen());
  }

  @override
  void onChatPressed() {
    _navigationService.navigateTo(const ChatListScreen());
  }

  @override
  void onThemeTogglePressed() {
    view?.showThemeToggle();
  }
}
