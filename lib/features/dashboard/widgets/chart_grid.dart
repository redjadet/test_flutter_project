import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/ui/layout.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Responsive grid that lays out [ChartCard]s in 1 or 2 columns.
/// Uses Wrap so item heights follow their content (no fixed row height).
class ChartGrid extends StatelessWidget {
  static const int _singleColumn = 1;
  static const int _twoColumns = 2;

  const ChartGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final charts = context.select((DashboardController c) => c.state.charts);

    if (charts.isEmpty) {
      return _buildEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) =>
          _buildGrid(context, charts, constraints),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(child: Text(loc.noCharts));
  }

  Widget _buildGrid(
    BuildContext context,
    List<ChartData> charts,
    BoxConstraints constraints,
  ) {
    final gridConfig = _calculateGridConfig(constraints);

    return Wrap(
      spacing: cardSpacing,
      runSpacing: cardSpacing,
      children: charts
          .map((chart) => _buildChartCard(chart, gridConfig.itemWidth))
          .toList(),
    );
  }

  _GridConfig _calculateGridConfig(BoxConstraints constraints) {
    final isWide = constraints.maxWidth >= gridTwoColMinWidth;
    final columns = isWide ? _twoColumns : _singleColumn;
    final totalSpacing = cardSpacing * (columns - 1);
    final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

    return _GridConfig(columns: columns, itemWidth: itemWidth);
  }

  Widget _buildChartCard(ChartData chart, double itemWidth) {
    return SizedBox(
      width: itemWidth,
      child: ChartCard(key: ValueKey(chart.id), chart: chart),
    );
  }
}

class _GridConfig {
  final int columns;
  final double itemWidth;

  const _GridConfig({required this.columns, required this.itemWidth});
}
