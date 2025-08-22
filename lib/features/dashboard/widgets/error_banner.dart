import 'package:complex_ui_openai/features/dashboard/presentation/dashboard_presenter.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorBanner extends StatelessWidget {
  static const EdgeInsets _bannerPadding = EdgeInsets.all(12);
  static const EdgeInsets _bannerMargin = EdgeInsets.only(bottom: 16);
  static const double _borderRadius = 8.0;
  static const double _iconSpacing = 8.0;
  static const double _darkAlpha = 0.22;
  static const double _darkBorderAlpha = 0.35;
  static const Color _lightBackgroundColor = Color(0xFFFFEBEE);
  static const Color _lightBorderColor = Color(0xFFE57373);

  const ErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select(
      (DashboardController c) => c.state.errorMessage,
    );
    if (errorMessage.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: _bannerPadding,
      margin: _bannerMargin,
      decoration: _buildDecoration(context),
      child: _buildContent(context, errorMessage),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color: _getBackgroundColor(scheme, isDark),
      borderRadius: BorderRadius.circular(_borderRadius),
      border: Border.all(color: _getBorderColor(scheme, isDark)),
    );
  }

  Color _getBackgroundColor(ColorScheme scheme, bool isDark) {
    return isDark
        ? scheme.errorContainer.withValues(alpha: _darkAlpha)
        : _lightBackgroundColor;
  }

  Color _getBorderColor(ColorScheme scheme, bool isDark) {
    return isDark
        ? scheme.onErrorContainer.withValues(alpha: _darkBorderAlpha)
        : _lightBorderColor;
  }

  Widget _buildContent(BuildContext context, String errorMessage) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = _getTextColor(scheme, isDark);

    return Row(
      children: [
        _buildErrorIcon(textColor),
        const SizedBox(width: _iconSpacing),
        _buildErrorMessage(errorMessage, textColor),
        _buildCloseButton(context, textColor),
      ],
    );
  }

  Color _getTextColor(ColorScheme scheme, bool isDark) {
    return isDark ? scheme.onErrorContainer : scheme.error;
  }

  Widget _buildErrorIcon(Color color) {
    return Icon(Icons.error, color: color);
  }

  Widget _buildErrorMessage(String errorMessage, Color color) {
    return Expanded(
      child: Text(errorMessage, style: TextStyle(color: color)),
    );
  }

  Widget _buildCloseButton(BuildContext context, Color color) {
    return IconButton(
      icon: const Icon(Icons.close),
      color: color,
      onPressed: () => _clearError(context),
    );
  }

  void _clearError(BuildContext context) {
    context.read<DashboardPresenter>().clearError();
  }
}
