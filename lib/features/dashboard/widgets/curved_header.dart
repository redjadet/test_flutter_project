import 'package:complex_ui_openai/core/theme/app_colors.dart';
import 'package:complex_ui_openai/shared/clipper/top_curved_clipper.dart';
import 'package:flutter/material.dart';

/// Decorative curved header used at the top of the dashboard.
///
/// Place inside a `Stack` with `Positioned` to anchor it.
class CurvedHeader extends StatelessWidget {
  final double height;
  final Color color;

  const CurvedHeader({
    super.key,
    this.height = 100,
    this.color = AppColors.tealMedium,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
        clipper: const TopCurvedClipper(),
        child: ColoredBox(color: color),
      ),
    );
  }
}
