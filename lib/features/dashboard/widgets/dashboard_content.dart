import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/features/dashboard/presentation/dashboard_presenter.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/widgets/chart_grid.dart';
import 'package:complex_ui/features/dashboard/widgets/error_banner.dart';
import 'package:complex_ui/features/dashboard/widgets/metric_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 16.0);
  static const double _maxWidth = 800.0;
  static const EdgeInsets _loadingPadding = EdgeInsets.all(32.0);
  static const double _dividerHeight = 32.0;
  static const double _dividerThickness = 2.0;
  static const double _sectionSpacing = 16.0;
  static const double _chartSectionSpacing = 24.0;
  static const double _chartTitleSpacing = 12.0;

  Future<void> _onRefresh(BuildContext context) async {
    final presenter = context.read<DashboardPresenter>();
    await presenter.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isLoading = context.select(
      (DashboardController c) => c.state.isLoading,
    );
    final userName = context.select(
      (DashboardController c) => c.state.userName,
    );

    return Padding(
      padding: _padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const ErrorBanner(),
                if (isLoading)
                  _buildLoadingIndicator()
                else
                  ..._buildContent(context, loc, userName),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: _loadingPadding,
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Widget> _buildContent(
    BuildContext context,
    AppLocalizations loc,
    String userName,
  ) {
    return [
      _buildWelcomeText(context, loc, userName),
      const Divider(thickness: _dividerThickness, height: _dividerHeight),
      const SizedBox(height: _sectionSpacing),
      const MetricList(),
      const SizedBox(height: _chartSectionSpacing),
      _buildStatisticsSection(context, loc),
    ];
  }

  Widget _buildWelcomeText(
    BuildContext context,
    AppLocalizations loc,
    String userName,
  ) {
    return Text(
      loc.welcomeBack(userName.isNotEmpty ? userName : ''),
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatisticsSection(BuildContext context, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.statistics,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: _chartTitleSpacing),
        const ChartGrid(),
      ],
    );
  }
}
