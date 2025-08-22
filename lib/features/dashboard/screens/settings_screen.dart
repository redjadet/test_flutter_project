import 'package:complex_ui_openai/core/l10n/app_localizations.dart';
import 'package:complex_ui_openai/core/services/navigation_service.dart';
import 'package:complex_ui_openai/features/dashboard/presentation/settings_presenter.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui_openai/features/dashboard/widgets/settings_sections.dart';
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
  static const double _fieldSpacing = 16.0;

  late final TextEditingController _nameController;
  late final SettingsPresenter _presenter;
  bool _dirty = false;
  bool _valid = true;

  @override
  void initState() {
    super.initState();
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
    final scheme = Theme.of(context).colorScheme;
    final themeMode = context.select(
      (DashboardController c) => c.state.themeMode,
    );
    final currentLocale = context.select(
      (DashboardController c) => c.state.localeCode,
    );
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: _contentPadding,
          children: [
            SettingsProfileSection(
              nameController: _nameController,
              isValid: _valid,
              isDirty: _dirty,
              onNameChanged: _onNameChanged,
              onSavePressed: _onSavePressed,
              loc: loc,
              scheme: scheme,
            ),
            const SizedBox(height: _fieldSpacing),
            SettingsThemeSection(
              themeMode: themeMode,
              onThemeChanged: _presenter.updateThemeMode,
              loc: loc,
            ),
            const SizedBox(height: _fieldSpacing),
            SettingsLocaleSection(
              currentLocale: currentLocale,
              onLocaleChanged: _presenter.updateLocale,
              loc: loc,
            ),
            const SizedBox(height: _fieldSpacing),
            SettingsBackendSection(presenter: _presenter, loc: loc),
            const SizedBox(height: _fieldSpacing),
            SettingsResetSection(
              onResetPressed: _presenter.resetToDefaults,
              loc: loc,
            ),
          ],
        ),
      ),
    );
  }
}
