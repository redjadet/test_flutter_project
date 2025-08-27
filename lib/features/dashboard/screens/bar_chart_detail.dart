import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/ui/chart_config.dart';
import 'package:complex_ui/core/ui/layout.dart';
import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_utils.dart';
import 'package:complex_ui/features/dashboard/widgets/detail_split_view.dart';
import 'package:complex_ui/features/dashboard/widgets/legend_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays detailed bar chart for a given index using the same data as the dashboard.
class BarChartDetailScreen extends StatelessWidget {
  static const String _fallbackId = 'fallback';
  static const String _fallbackTitle = 'Details';

  final String chartId;

  const BarChartDetailScreen({super.key, required this.chartId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final chart = _getChart(context);

    return Scaffold(
      appBar: _buildAppBar(chart, loc),
      body: SafeArea(
        child: DetailSplitView(
          chartBuilder: (context, chartW, chartH, isNarrow) =>
              _buildBarChart(chartW, chartH),
          legendBuilder: (context, isNarrow) => _buildLegend(isNarrow),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChartData chart, AppLocalizations loc) {
    return AppBar(
      title: Text(chart.title.isNotEmpty ? chart.title : loc.statistics),
    );
  }

  Widget _buildBarChart(double chartW, double chartH) {
    return Builder(
      builder: (context) {
        final chart = _getChart(context);
        return SizedBox(
          width: chartW,
          height: chartH,
          child: BarChart(
            buildBarChartData(
              chart.data,
              barWidth: barWidthDetail,
              leftReservedSize: barLeftReservedSizeDetail,
              leftInterval: barLeftInterval,
              leftStyle: axisLabelSmall,
              bottomStyle: axisLabelSmall,
              alignment: defaultBarAlignment,
            ),
            duration: barSwapDuration,
            curve: barSwapCurve,
          ),
        );
      },
    );
  }

  Widget _buildLegend(bool isNarrow) {
    return Builder(
      builder: (context) {
        final chart = _getChart(context);
        return LegendPanel(
          data: chart.data,
          layout: LegendLayout.list,
          shrinkWrap: isNarrow,
        );
      },
    );
  }

  ChartData _getChart(BuildContext context) {
    final charts = context.select((DashboardController c) => c.state.charts);
    return charts.firstWhere(
      (c) => c.id == chartId,
      orElse: () => _createFallbackChart(charts),
    );
  }

  ChartData _createFallbackChart(List<ChartData> charts) {
    return charts.isNotEmpty
        ? charts.first
        : const ChartData(
            id: _fallbackId,
            title: _fallbackTitle,
            data: <PieSlice>[],
            type: ChartType.bar,
          );
  }
}
