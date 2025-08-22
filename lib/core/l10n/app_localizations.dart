import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Minimal runtime localizations loader using ARB files in /l10n.
/// This keeps strings separated from code (per-locale files) without codegen.
class AppLocalizations {
  final Locale locale;
  late final Map<String, dynamic> _strings;

  AppLocalizations._(this.locale, this._strings);

  static const supportedLocales = [Locale('en'), Locale('tr')];

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common getters
  String get dashboardTitle => _str('dashboardTitle');
  String get statistics => _str('statistics');
  String get noCharts => _str('noCharts');
  String get noMetrics => _str('noMetrics');
  String get openChartDetailsTooltip => _str('openChartDetailsTooltip');
  String get openBarChartDetailsSemantics =>
      _str('openBarChartDetailsSemantics');
  // Settings strings
  String get settingsTitle => _str('settingsTitle');
  String get profile => _str('profile');
  String get yourName => _str('yourName');
  String get nameTooShort => _str('nameTooShort');
  String get save => _str('save');
  String get settingsSaved => _str('settingsSaved');
  String get appearance => _str('appearance');
  String get light => _str('light');
  String get dark => _str('dark');
  String get system => _str('system');
  String get storage => _str('storage');
  String get file => _str('file');
  String get database => _str('database');
  String get language => _str('language');
  String get english => _str('english');
  String get turkish => _str('turkish');
  String get resetToDefaults => _str('resetToDefaults');
  String get settingsReset => _str('settingsReset');
  String get dangerZone => _str('dangerZone');
  String get confirmResetTitle => _str('confirmResetTitle');
  String get confirmResetMessage => _str('confirmResetMessage');
  String get cancel => _str('cancel');
  String get confirm => _str('confirm');

  // Placeholders
  String welcomeBack(String name) =>
      _str('welcomeBack').replaceAll('{name}', name);
  String chartDetailTitle(int number) =>
      _str('chartDetailTitle').replaceAll('{number}', '$number');
  String storageSwitched(String backend) =>
      _str('storageSwitched').replaceAll('{backend}', backend);

  String _str(String key) {
    final val = _strings[key];
    if (val is String) return val;
    return key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final lang =
        AppLocalizations.supportedLocales.any(
          (l) => l.languageCode == locale.languageCode,
        )
        ? locale.languageCode
        : 'en';
    final path = 'l10n/app_$lang.arb';
    final data = await rootBundle.loadString(path);
    final map = json.decode(data) as Map<String, dynamic>;
    // Filter out metadata keys that start with '@' as per ARB.
    final strings = <String, dynamic>{}
      ..addEntries(map.entries.where((e) => !e.key.startsWith('@')));
    return SynchronousFuture(AppLocalizations._(locale, strings));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
