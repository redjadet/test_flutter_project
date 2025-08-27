import 'package:complex_ui/core/l10n/app_localizations.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/dashboard/presentation/settings_presenter.dart';
import 'package:complex_ui/features/dashboard/state/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameEditor extends StatefulWidget {
  const UsernameEditor({super.key});

  @override
  State<UsernameEditor> createState() => _UsernameEditorState();
}

class _UsernameEditorState extends State<UsernameEditor> {
  late final TextEditingController _controller;
  late final SettingsPresenter _presenter;

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
    _controller = TextEditingController(text: controller.state.userName);
    _presenter = SettingsPresenter(controller, navigationService);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    FocusScope.of(context).unfocus();
    _presenter.onSavePressed(name);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: loc.yourName,
              isDense: true,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: scheme.primary),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save),
          label: Text(loc.save),
        ),
      ],
    );
  }
}
