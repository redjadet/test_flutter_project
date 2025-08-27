import 'dart:math' as math;

import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/core/ui/chart_config.dart';
import 'package:complex_ui/core/ui/layout.dart';
import 'package:complex_ui/features/dashboard/presentation/chart_presenter.dart';
import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_utils.dart';
import 'package:complex_ui/features/dashboard/widgets/legend_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Card combining a bar chart, pie chart, and generated legend.
class ChartCard extends StatefulWidget {
  static const double _minWidth = 280.0;
  static const EdgeInsets _cardPadding = EdgeInsets.all(8.0);
  static const double _sectionSpacing = 20.0;
  static const int _chartFlex = 2;
  static const int _legendFlex = 1;

  final ChartData chart;

  const ChartCard({super.key, required this.chart});

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  late final ChartPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _initializePresenter();
  }

  void _initializePresenter() {
    final navigationService = Provider.of<NavigationService>(
      context,
      listen: false,
    );
    _presenter = ChartPresenter(navigationService);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ChartPresenter>.value(
      value: _presenter,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: ChartCard._minWidth),
          child: Padding(
            padding: ChartCard._cardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: ChartCard._chartFlex,
                  child: _BarChartSection(chart: widget.chart),
                ),
                const SizedBox(width: ChartCard._sectionSpacing),
                Expanded(
                  flex: ChartCard._legendFlex,
                  child: LegendPanel(
                    data: widget.chart.data,
                    layout: LegendLayout.wrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact bar chart area built from the same data; tapping opens [BarChartDetailScreen].
class _BarChartSection extends StatelessWidget {
  static const double _minHeight = 140.0;
  static const double _heightRatio = 0.6;

  final ChartData chart;

  const _BarChartSection({required this.chart});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = _calculateDimensions(constraints);

        return Center(
          child: SizedBox(
            width: dimensions.width,
            height: dimensions.height,
            child: Stack(
              fit: StackFit.expand,
              children: [_buildBarChart(), _buildTapOverlay(context)],
            ),
          ),
        );
      },
    );
  }

  _ChartDimensions _calculateDimensions(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height =
        constraints.hasBoundedHeight && constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : math.max(_minHeight, width * _heightRatio);

    return _ChartDimensions(width: width, height: height);
  }

  Widget _buildBarChart() {
    return BarChart(
      buildBarChartData(
        chart.data,
        barWidth: barWidthCard,
        leftReservedSize: barLeftReservedSizeSmall,
        leftInterval: barLeftInterval,
        leftStyle: axisLabelSmall,
        bottomStyle: axisLabelTiny,
        alignment: defaultBarAlignment,
      ),
      duration: barSwapDuration,
      curve: barSwapCurve,
    );
  }

  Widget _buildTapOverlay(BuildContext context) {
    return Positioned.fill(
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          return Semantics(
            button: true,
            label: loc.openBarChartDetailsSemantics,
            child: Tooltip(
              message: loc.openChartDetailsTooltip,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: () => _onChartTap(context)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onChartTap(BuildContext context) {
    final presenter = context.read<ChartPresenter>();
    presenter.onChartTap(chart.id);
  }
}

class _ChartDimensions {
  final double width;
  final double height;

  const _ChartDimensions({required this.width, required this.height});
}
