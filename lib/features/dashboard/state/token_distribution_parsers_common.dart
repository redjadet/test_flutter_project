import 'package:complex_ui_openai/core/theme/app_colors.dart';
import 'package:complex_ui_openai/features/dashboard/data/pie_data.dart';
import 'package:flutter/material.dart';

// Public so multiple parser files can share it.
const List<Color> distributionPalette = <Color>[
  AppColors.tealMedium,
  AppColors.blue,
  AppColors.orangeAccent,
  AppColors.redDark,
  AppColors.purple,
  AppColors.red,
  AppColors.indigo,
  AppColors.yellow,
  AppColors.pink,
  AppColors.grey,
];

List<PieSlice>? mapSimpleList(List list) {
  final slices = <PieSlice>[];
  for (var i = 0; i < list.length; i++) {
    final e = list[i];
    if (e is! Map) continue;
    final label = (e['label'] as String?)?.trim();
    final percent = (e['percent'] as num?)?.toDouble();
    if (label == null || percent == null) continue;
    final color = distributionPalette[i % distributionPalette.length];
    slices.add(
      PieSlice(
        value: percent,
        color: color,
        title: '${percent.toStringAsFixed(0)}%',
        legend: '$label – ${percent.toStringAsFixed(1)}%',
      ),
    );
  }
  if (slices.isEmpty) return null;
  return slices;
}

List<PieSlice>? extractDistributionFromMap(Map body) {
  List<Map<String, dynamic>>? found;
  void dfs(dynamic node) {
    if (found != null) return;
    if (node is List) {
      final maps = node.whereType<Map>().cast<Map>().toList();
      final looksLike =
          maps.isNotEmpty &&
          maps.every((m) {
            final hasLabel = m.containsKey('label') && m['label'] is String;
            final hasPercent =
                m.containsKey('percent') && (m['percent'] is num);
            return hasLabel && hasPercent;
          });
      if (looksLike) {
        found = maps.cast<Map<String, dynamic>>();
        return;
      }
    } else if (node is Map) {
      for (final v in node.values) {
        dfs(v);
        if (found != null) return;
      }
    }
  }

  dfs(body);
  if (found == null) return null;
  return mapSimpleList(found!);
}

String toPlainText(String s) {
  var out = s.replaceAll(RegExp(r'<[^>]+>'), ' ');
  out = out
      .replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'&amp;', caseSensitive: false), '&')
      .replaceAll(
        RegExp(r'&ndash;|&mdash;|&#8211;|&#8212;', caseSensitive: false),
        '–',
      )
      .replaceAll(RegExp(r'&quot;|&#34;', caseSensitive: false), '"')
      .replaceAll(RegExp(r'&#39;|&apos;', caseSensitive: false), "'");
  out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
    final code = int.tryParse(m.group(1) ?? '');
    return code == null ? '' : String.fromCharCode(code);
  });
  out = out.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (m) {
    final code = int.tryParse(m.group(1) ?? '', radix: 16);
    return code == null ? '' : String.fromCharCode(code);
  });
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
  return out;
}

String stripStyleScript(String html) {
  var s = html;
  s = s.replaceAll(RegExp(r'<style[\s\S]*?</style>', caseSensitive: false), '');
  s = s.replaceAll(
    RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
    '',
  );
  return s;
}
