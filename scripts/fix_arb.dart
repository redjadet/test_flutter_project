import 'dart:convert';
import 'dart:io';

/// Simple ARB auto-fixer:
/// - Pretty prints with 2 spaces
/// - Sorts message keys alphabetically
/// - Places @@locale first if present
/// - Places metadata entries ("@key") immediately after their key
Future<void> main(List<String> args) async {
  final dir = Directory('l10n');
  if (!await dir.exists()) return;

  final arbFiles = await dir
      .list(recursive: false)
      .where((e) => e is File && e.path.endsWith('.arb'))
      .cast<File>()
      .toList();

  for (final file in arbFiles) {
    try {
      final raw = await file.readAsString();
      final map = json.decode(raw) as Map<String, dynamic>;

      final out = <String, dynamic>{};

      // 1) @@locale at top if present
      if (map.containsKey('@@locale')) {
        out['@@locale'] = map['@@locale'];
      }

      // Collect base keys (non-metadata, not starting with '@')
      final baseKeys =
          map.keys.where((k) => !k.startsWith('@') && k != '@@locale').toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      for (final key in baseKeys) {
        out[key] = map[key];
        final metaKey = '@$key';
        if (map.containsKey(metaKey)) {
          out[metaKey] = map[metaKey];
        }
      }

      // Add remaining top-level metadata (e.g., @@last_modified) not already added
      for (final entry in map.entries) {
        final k = entry.key;
        if (k == '@@locale') continue;
        if (k.startsWith('@@')) {
          if (!out.containsKey(k)) {
            out[k] = entry.value;
          }
        }
      }

      const encoder = JsonEncoder.withIndent('  ');
      final text = '${encoder.convert(out)}\n';
      if (text != raw) {
        await file.writeAsString(text);
        stdout.writeln('[fix_arb] Formatted ${file.path}');
      }
    } catch (e) {
      stderr.writeln('[fix_arb] Skipped ${file.path}: $e');
    }
  }
}
