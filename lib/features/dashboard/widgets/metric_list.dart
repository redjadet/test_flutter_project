import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Horizontal list of [MetricCard] tiles.

class MetricList extends StatelessWidget {
  const MetricList({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = context.select((DashboardController c) => c.state.metrics);

    if (metrics.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      return SizedBox(height: 240, child: Center(child: Text(loc.noMetrics)));
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: metrics.length,
        itemBuilder: (context, i) => MetricCard(metric: metrics[i]),
      ),
    );
  }
}
