import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:complex_ui/features/dashboard/widgets/legend_entry.dart';
import 'package:flutter/material.dart';

enum LegendLayout { list, wrap }

/// Reusable legend panel for charts to avoid duplication across views.
class LegendPanel extends StatelessWidget {
  final List<PieSlice> data;
  final LegendLayout layout;
  final bool shrinkWrap;
  final double spacing;

  const LegendPanel({
    super.key,
    required this.data,
    this.layout = LegendLayout.list,
    this.shrinkWrap = false,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case LegendLayout.list:
        return ListView(
          shrinkWrap: shrinkWrap,
          children: [
            for (final s in data) LegendEntry(color: s.color, label: s.legend),
          ],
        );
      case LegendLayout.wrap:
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            // Use 1 column on very narrow panels, otherwise 2 columns.
            final columns = w < 220 ? 1 : 2;
            final totalSpacing = spacing * (columns - 1);
            final itemWidth = (w - totalSpacing) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final s in data)
                  SizedBox(
                    width: itemWidth,
                    child: LegendEntry(color: s.color, label: s.legend),
                  ),
              ],
            );
          },
        );
    }
  }
}
