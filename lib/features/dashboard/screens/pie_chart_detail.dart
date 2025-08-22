import 'package:complex_ui_openai/core/l10n/app_localizations.dart';
import 'package:complex_ui_openai/features/dashboard/data/pie_data.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui_openai/features/dashboard/state/models.dart';
import 'package:complex_ui_openai/features/dashboard/widgets/detail_split_view.dart';
import 'package:complex_ui_openai/features/dashboard/widgets/legend_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Uses shared data and builders for consistent theming and behavior.

/// Displays detailed pie chart for a given index.
class PieChartDetailScreen extends StatelessWidget {
  final String chartId;
  const PieChartDetailScreen({super.key, required this.chartId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final charts = context.select((DashboardController c) => c.state.charts);
    final chart = charts.firstWhere(
      (c) => c.id == chartId,
      orElse: () => charts.isNotEmpty
          ? charts.first
          : const ChartData(
              id: 'fallback',
              title: 'Details',
              data: <PieSlice>[],
              type: ChartType.pie,
            ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(chart.title.isNotEmpty ? chart.title : loc.statistics),
      ),
      body: SafeArea(
        child: DetailSplitView(
          chartBuilder: (context, chartW, chartH, isNarrow) {
            // Compute a square side based on available chart area; then derive radius/center.
            final chartSide = (chartW < chartH ? chartW : chartH) * 0.96;
            final radius = (chartSide / 2) * 0.96;
            final center = radius * 0.20;
            return Center(
              child: SizedBox(
                width: chartSide,
                height: chartSide,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0.6,
                    centerSpaceRadius: center,
                    sections: buildPieSectionsFrom(
                      chart.data,
                      radius: radius,
                      sectionsSpace: 0.6,
                      showTitles: true,
                    ),
                  ),
                ),
              ),
            );
          },
          legendBuilder: (context, isNarrow) => LegendPanel(
            data: chart.data,
            layout: LegendLayout.list,
            shrinkWrap: isNarrow,
          ),
        ),
      ),
    );
  }
}
