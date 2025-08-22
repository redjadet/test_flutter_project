import 'package:complex_ui_openai/core/l10n/app_localizations.dart';
import 'package:complex_ui_openai/features/dashboard/presentation/settings_presenter.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:complex_ui_openai/features/dashboard/state/persistence_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProfileSection extends StatelessWidget {
  final TextEditingController nameController;
  final bool isValid;
  final bool isDirty;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSavePressed;
  final AppLocalizations loc;
  final ColorScheme scheme;

  const SettingsProfileSection({
    super.key,
    required this.nameController,
    required this.isValid,
    required this.isDirty,
    required this.onNameChanged,
    required this.onSavePressed,
    required this.loc,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.profile, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: loc.yourName,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: scheme.primary),
            ),
            errorText: isValid ? null : loc.nameTooShort,
          ),
          textInputAction: TextInputAction.done,
          onChanged: onNameChanged,
          onSubmitted: (_) => onSavePressed(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: isDirty && isValid ? onSavePressed : null,
            icon: const Icon(Icons.save),
            label: Text(loc.save),
          ),
        ),
      ],
    );
  }
}

class SettingsThemeSection extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final AppLocalizations loc;

  const SettingsThemeSection({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.appearance, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        DropdownButtonFormField<ThemeMode>(
          initialValue: themeMode,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: ThemeMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(_localizedThemeMode(loc, mode)),
            );
          }).toList(),
          onChanged: (mode) {
            if (mode != null) onThemeChanged(mode);
          },
        ),
      ],
    );
  }

  String _localizedThemeMode(AppLocalizations loc, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return loc.light;
      case ThemeMode.dark:
        return loc.dark;
      case ThemeMode.system:
        return loc.system;
    }
  }
}

class SettingsLocaleSection extends StatelessWidget {
  final String currentLocale;
  final ValueChanged<String> onLocaleChanged;
  final AppLocalizations loc;

  const SettingsLocaleSection({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.language, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: currentLocale,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: [
            DropdownMenuItem(value: 'en', child: Text(loc.english)),
            DropdownMenuItem(value: 'tr', child: Text(loc.turkish)),
          ],
          onChanged: (locale) {
            if (locale != null) onLocaleChanged(locale);
          },
        ),
      ],
    );
  }
}

class SettingsBackendSection extends StatelessWidget {
  final ISettingsPresenter presenter;
  final AppLocalizations loc;

  const SettingsBackendSection({
    super.key,
    required this.presenter,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.storage, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        FutureBuilder<PersistenceBackend>(
          future: presenter.currentBackend(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return DropdownButtonFormField<PersistenceBackend>(
              initialValue: snapshot.data,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: PersistenceBackend.values.map((backend) {
                return DropdownMenuItem(
                  value: backend,
                  child: Text(_localizedBackend(loc, backend)),
                );
              }).toList(),
              onChanged: (backend) async {
                if (backend != null) {
                  final controller = Provider.of<DashboardController>(
                    context,
                    listen: false,
                  );
                  await presenter.switchBackend(backend, controller.state);
                }
              },
            );
          },
        ),
      ],
    );
  }

  String _localizedBackend(AppLocalizations loc, PersistenceBackend backend) {
    switch (backend) {
      case PersistenceBackend.file:
        return loc.file;
      case PersistenceBackend.hive:
        return loc.database;
    }
  }
}

class SettingsResetSection extends StatelessWidget {
  final VoidCallback onResetPressed;
  final AppLocalizations loc;

  const SettingsResetSection({
    super.key,
    required this.onResetPressed,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.dangerZone, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onResetPressed,
          icon: const Icon(Icons.restore),
          label: Text(loc.resetToDefaults),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
