import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/dashboard/presentation/dashboard_presenter.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The main dashboard screen displaying metrics and charts.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    implements DashboardView {
  static const double _headerHeight = 50.0;
  static const double _contentTopOffset = 55.0;

  late final DashboardPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _initializePresenter();
  }

  void _initializePresenter() {
    final controller = Provider.of<DashboardController>(context, listen: false);
    final navigationService = Provider.of<NavigationService>(
      context,
      listen: false,
    );
    _presenter = DashboardPresenter(controller, navigationService);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _presenter.attachView(this);
      _presenter.init();
    });
  }

  @override
  void dispose() {
    _presenter.detachView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Provider<DashboardPresenter>.value(
      value: _presenter,
      child: Scaffold(
        appBar: _buildAppBar(context, loc, scheme),
        body: _buildBody(scheme),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations loc,
    ColorScheme scheme,
  ) {
    return AppBar(
      elevation: 0,
      flexibleSpace: _buildAppBarBackground(scheme),
      title: Text(loc.dashboardTitle),
      leading: _buildSettingsButton(),
      centerTitle: true,
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildAppBarBackground(ColorScheme scheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: _presenter.onSettingsPressed,
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.chat_bubble_outline),
        tooltip: 'Chats',
        onPressed: _presenter.onChatPressed,
      ),
      IconButton(
        icon: const Icon(Icons.brightness_6),
        tooltip: 'Toggle light/dark',
        onPressed: _presenter.onThemeTogglePressed,
      ),
    ];
  }

  Widget _buildBody(ColorScheme scheme) {
    return SafeArea(
      child: Stack(children: [_buildHeader(scheme), _buildContent()]),
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: _headerHeight,
      child: CurvedHeader(color: scheme.primary),
    );
  }

  Widget _buildContent() {
    return const Positioned.fill(
      top: _contentTopOffset,
      child: DashboardContent(),
    );
  }

  @override
  void showThemeToggle() {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    _presenter.toggleTheme(platformBrightness);
  }
}
