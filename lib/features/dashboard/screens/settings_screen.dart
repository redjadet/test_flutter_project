import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/dashboard/presentation/settings_presenter.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui/features/dashboard/widgets/settings_sections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    implements SettingsView {
  static const EdgeInsets _contentPadding = EdgeInsets.all(16.0);
  static const double _sectionSpacing = 16.0;

  late final TextEditingController _nameController;
  late final SettingsPresenter _presenter;
  bool _dirty = false;
  bool _valid = true;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    _initializePresenter();
    _initializeNameController();
  }

  void _initializePresenter() {
    final controller = Provider.of<DashboardController>(context, listen: false);
    final navigationService = Provider.of<NavigationService>(
      context,
      listen: false,
    );
    _presenter = SettingsPresenter(controller, navigationService);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _presenter.attachView(this);
    });
  }

  void _initializeNameController() {
    final controller = Provider.of<DashboardController>(context, listen: false);
    _nameController = TextEditingController(text: controller.state.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _presenter.detachView();
    super.dispose();
  }

  void _onNameChanged(String value) {
    final controller = Provider.of<DashboardController>(context, listen: false);
    final changed = value.trim() != controller.state.userName.trim();

    setState(() {
      _dirty = changed;
      _valid = _presenter.isNameValid(value);
    });
  }

  void _onSavePressed() {
    _presenter.onSavePressed(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final themeMode = context.select(
      (DashboardController c) => c.state.themeMode,
    );
    final currentLocale = context.select(
      (DashboardController c) => c.state.localeCode,
    );

    return Scaffold(
      appBar: _buildAppBar(loc),
      body: _buildBody(loc, scheme, themeMode, currentLocale),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations loc) {
    return AppBar(title: Text(loc.settingsTitle));
  }

  Widget _buildBody(
    AppLocalizations loc,
    ColorScheme scheme,
    ThemeMode themeMode,
    String currentLocale,
  ) {
    return SafeArea(
      child: ListView(
        padding: _contentPadding,
        children: [
          _buildProfileSection(loc, scheme),
          const SizedBox(height: _sectionSpacing),
          _buildThemeSection(loc, themeMode),
          const SizedBox(height: _sectionSpacing),
          _buildLocaleSection(loc, currentLocale),
          const SizedBox(height: _sectionSpacing),
          _buildBackendSection(loc),
          const SizedBox(height: _sectionSpacing),
          _buildResetSection(loc),
        ],
      ),
    );
  }

  Widget _buildProfileSection(AppLocalizations loc, ColorScheme scheme) {
    return SettingsProfileSection(
      nameController: _nameController,
      isValid: _valid,
      isDirty: _dirty,
      onNameChanged: _onNameChanged,
      onSavePressed: _onSavePressed,
      loc: loc,
      scheme: scheme,
    );
  }

  Widget _buildThemeSection(AppLocalizations loc, ThemeMode themeMode) {
    return SettingsThemeSection(
      themeMode: themeMode,
      onThemeChanged: _presenter.updateThemeMode,
      loc: loc,
    );
  }

  Widget _buildLocaleSection(AppLocalizations loc, String currentLocale) {
    return SettingsLocaleSection(
      currentLocale: currentLocale,
      onLocaleChanged: _presenter.updateLocale,
      loc: loc,
    );
  }

  Widget _buildBackendSection(AppLocalizations loc) {
    return SettingsBackendSection(presenter: _presenter, loc: loc);
  }

  Widget _buildResetSection(AppLocalizations loc) {
    return SettingsResetSection(
      onResetPressed: _presenter.resetToDefaults,
      loc: loc,
    );
  }
}
