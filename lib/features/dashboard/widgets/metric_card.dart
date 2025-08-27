import 'package:complex_ui/core/theme/app_colors.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_provider.dart';
import 'package:flutter/material.dart';

/// Displays a single summary metric with icon, value, and label.
class MetricCard extends StatelessWidget {
  static const double _cardWidth = 120.0;
  static const EdgeInsets _cardMargin = EdgeInsets.only(right: 10);
  static const double _borderRadius = 16.0;
  static const double _cardElevation = 4.0;
  static const EdgeInsets _cardPadding = EdgeInsets.all(8.0);
  static const double _iconSize = 28.0;
  static const double _iconSpacing = 4.0;
  static const double _titleSpacing = 2.0;
  static const double _valueSpacing = 2.0;
  static const double _trendIconSize = 12.0;
  static const double _trendSpacing = 2.0;
  static const double _titleFontSize = 11.0;
  static const double _valueFontSize = 16.0;
  static const double _trendFontSize = 10.0;
  static const int _titleMaxLines = 2;

  final MetricData metric;
  const MetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: _cardMargin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      elevation: _cardElevation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          width: _cardWidth,
          padding: _cardPadding,
          decoration: _buildGradientDecoration(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
                const SizedBox(height: _iconSpacing),
                _buildTitle(),
                const SizedBox(height: _titleSpacing),
                _buildValue(),
                const SizedBox(height: _valueSpacing),
                _buildTrendIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.redLight, AppColors.red],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
    );
  }

  Widget _buildIcon() {
    return Flexible(
      child: Icon(metric.icon, size: _iconSize, color: Colors.white),
    );
  }

  Widget _buildTitle() {
    return Flexible(
      child: Text(
        metric.title,
        style: const TextStyle(
          fontSize: _titleFontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        maxLines: _titleMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildValue() {
    return Flexible(
      child: Text(
        _formatValue(),
        style: const TextStyle(
          fontSize: _valueFontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatValue() {
    final decimalPlaces = metric.unit == '%' ? 1 : 0;
    return '${metric.value.toStringAsFixed(decimalPlaces)}${metric.unit}';
  }

  Widget _buildTrendIndicator() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTrendIcon(),
          const SizedBox(width: _trendSpacing),
          _buildTrendText(),
        ],
      ),
    );
  }

  Widget _buildTrendIcon() {
    return Icon(
      metric.isPositive ? Icons.trending_up : Icons.trending_down,
      size: _trendIconSize,
      color: metric.isPositive ? AppColors.greenLight : AppColors.redLight,
    );
  }

  Widget _buildTrendText() {
    return Text(
      '${metric.percentage.toStringAsFixed(1)}%',
      style: TextStyle(
        fontSize: _trendFontSize,
        color: metric.isPositive ? AppColors.greenLight : AppColors.redLight,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
