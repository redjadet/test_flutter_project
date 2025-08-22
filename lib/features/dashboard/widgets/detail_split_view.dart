import 'package:complex_ui_openai/core/ui/layout.dart';
import 'package:flutter/material.dart';

/// Generic responsive split view for chart (left/top) and legend (right/bottom).
/// - On narrow screens (< `narrowWidth`), stacks chart above legend in a scroll view.
/// - On wide screens, lays out chart and legend side-by-side with a fixed legend width.
class DetailSplitView extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    double chartWidth,
    double chartHeight,
    bool isNarrow,
  )
  chartBuilder;
  final Widget Function(BuildContext context, bool isNarrow) legendBuilder;
  final EdgeInsetsGeometry padding;
  final double legendFraction; // portion of total width reserved for legend

  const DetailSplitView({
    super.key,
    required this.chartBuilder,
    required this.legendBuilder,
    this.padding = const EdgeInsets.all(8.0),
    this.legendFraction = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalW = constraints.maxWidth;
          final totalH = constraints.maxHeight > 0
              ? constraints.maxHeight
              : constraints.biggest.height;

          final legendW = (totalW * legendFraction) < legendMaxWidth
              ? (totalW * legendFraction)
              : legendMaxWidth;
          const gap = layoutGap;

          final isNarrow = totalW < narrowWidth;

          if (isNarrow) {
            final chartH = totalH * 0.55; // leave room for legend below
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  chartBuilder(context, totalW, chartH, true),
                  const SizedBox(height: gap),
                  legendBuilder(context, true),
                ],
              ),
            );
          }

          final chartW = (totalW - legendW - gap).clamp(0.0, double.infinity);
          final chartH = totalH * 0.9;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: chartBuilder(context, chartW, chartH, false)),
              const SizedBox(width: gap),
              SizedBox(
                width: legendW,
                height: totalH,
                child: legendBuilder(context, false),
              ),
            ],
          );
        },
      ),
    );
  }
}
