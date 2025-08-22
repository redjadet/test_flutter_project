import 'dart:convert';

import 'package:complex_ui_openai/core/theme/app_colors.dart';
import 'package:complex_ui_openai/features/dashboard/data/pie_data.dart';

import 'package:complex_ui_openai/features/dashboard/state/token_distribution_parsers_common.dart';

List<PieSlice>? extractFromCoinMarketCapHtml(String html) {
  final re = RegExp(
    r'<script id="__NEXT_DATA__" type="application/json">(.*?)</script>',
    dotAll: true,
  );
  final m = re.firstMatch(html);
  if (m == null) return null;
  final jsonText = m.group(1);
  if (jsonText == null || jsonText.isEmpty) return null;
  dynamic data;
  try {
    data = jsonDecode(jsonText);
  } catch (_) {
    return null;
  }
  final alloc = extractAllocationsFromNextData(data);
  if (alloc != null && alloc.isNotEmpty) return alloc;

  double? circulating;
  double? total;
  void dfsSupply(dynamic node) {
    if (circulating != null && total != null) return;
    if (node is Map) {
      final cs = node['circulatingSupply'] ?? node['circulating_supply'];
      final ts =
          node['totalSupply'] ?? node['total_supply'] ?? node['maxSupply'];
      if (cs is num && ts is num) {
        circulating = cs.toDouble();
        total = ts.toDouble();
        return;
      }
      for (final v in node.values) {
        dfsSupply(v);
        if (circulating != null && total != null) return;
      }
    } else if (node is List) {
      for (final v in node) {
        dfsSupply(v);
        if (circulating != null && total != null) return;
      }
    }
  }

  dfsSupply(data);
  if (circulating == null || total == null || total! <= 0) return null;
  if (circulating! > total!) {
    final tmp = circulating!;
    circulating = total;
    total = tmp;
  }
  final nonCirc = (total! - circulating!).clamp(0, double.infinity);
  final circPct = (circulating! / total!) * 100.0;
  final nonPct = (nonCirc / total!) * 100.0;

  return [
    PieSlice(
      value: double.parse(circPct.toStringAsFixed(2)),
      color: AppColors.tealMedium,
      title: '${circPct.toStringAsFixed(0)}%',
      legend: 'Circulating – ${circPct.toStringAsFixed(1)}%',
    ),
    PieSlice(
      value: double.parse(nonPct.toStringAsFixed(2)),
      color: AppColors.orangeAccent,
      title: '${nonPct.toStringAsFixed(0)}%',
      legend: 'Non-circulating – ${nonPct.toStringAsFixed(1)}%',
    ),
  ];
}

List<PieSlice>? extractAllocationsFromNextData(dynamic node) {
  final entryRe = RegExp(
    r'(\d+(?:\.\d+)?)%\s*(?:[-–]\s*)?([^\n\r,\.]+)'
    r'(?:[\.,\n\r]|$)',
    caseSensitive: false,
  );
  List<RegExpMatch> bestMatches = const [];

  void dfs(dynamic n) {
    if (n is String) {
      final text = toPlainText(n);
      final ms = entryRe.allMatches(text).toList();
      if (ms.length > bestMatches.length) {
        bestMatches = ms;
      }
    } else if (n is Map) {
      for (final v in n.values) {
        dfs(v);
      }
    } else if (n is List) {
      for (final v in n) {
        dfs(v);
      }
    }
  }

  dfs(node);
  if (bestMatches.isEmpty) return null;

  final slices = <PieSlice>[];
  for (var i = 0; i < bestMatches.length; i++) {
    final g = bestMatches[i];
    final pctStr = g.group(1);
    var label = toPlainText((g.group(2) ?? '').trim());
    label = label.replaceAll(RegExp(r'\\n+'), ' ').trim();
    label = label.replaceAll(RegExp(r'^[^A-Za-z0-9]+'), '').trim();
    if (pctStr == null || pctStr.isEmpty || label.isEmpty) continue;
    final pct = double.tryParse(pctStr);
    if (pct == null) continue;
    final lc = label.toLowerCase();
    if (label.startsWith('(') ||
        RegExp(
          r'\b(1d|7d|24h|30d|90d|ytd|1y)\b',
          caseSensitive: false,
        ).hasMatch(lc)) {
      continue;
    }
    label = label.replaceAll(RegExp(r'[-–:]+$'), '').trim();
    label = label[0].toUpperCase() + label.substring(1);
    final color = distributionPalette[i % distributionPalette.length];
    final isStaking =
        label.toLowerCase().contains('staking') &&
        label.toLowerCase().contains('reward');
    final legendText = isStaking
        ? 'Staking rewards - ${pct.toStringAsFixed(0)}%'
        : '$label – ${pct.toStringAsFixed(2)}%';
    slices.add(
      PieSlice(
        value: double.parse(pct.toStringAsFixed(2)),
        color: color,
        title: '${pct.toStringAsFixed(0)}%',
        legend: legendText,
      ),
    );
  }
  return slices.isEmpty ? null : slices;
}

List<PieSlice>? extractFromCoinMarketCapAbout(String html) {
  final headingPattern = RegExp(
    r'How Many Avalanche \(AVAX\) Coins Are There in Circulation\?',
    caseSensitive: false,
  );
  final m = headingPattern.firstMatch(html);
  if (m == null) return null;

  final start = m.start;
  final endHint = html.indexOf(
    RegExp(r'<h2|<h3', caseSensitive: false),
    start + 1,
  );
  final rawSection = html.substring(
    start,
    endHint != -1 ? endHint : html.length,
  );

  final sectionNoCode = stripStyleScript(rawSection);
  final textish = toPlainText(sectionNoCode)
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(
        RegExp(r'</p>|</li>|</div>|</h\d>', caseSensitive: false),
        '\n',
      )
      .replaceAll(RegExp(r'<[^>]+>'), '');

  final entryRe = RegExp(
    r'(\d+(?:\.\d+)?)%\s*(?:[-–]\s*)?([^\n\r,\.]+)'
    r'(?:[\.,\n\r]|$)',
    caseSensitive: false,
  );
  final matches = entryRe.allMatches(textish).toList();
  if (matches.isEmpty) return null;

  final slices = <PieSlice>[];
  for (var i = 0; i < matches.length; i++) {
    final g = matches[i];
    final pctStr = g.group(1);
    var label = toPlainText((g.group(2) ?? '').trim());
    label = label.replaceAll(RegExp(r'\\n+'), ' ').trim();
    label = label.replaceAll(RegExp(r'^[^A-Za-z0-9]+'), '').trim();
    if (pctStr == null || pctStr.isEmpty || label.isEmpty) continue;
    final pct = double.tryParse(pctStr);
    if (pct == null) continue;
    final lc = label.toLowerCase();
    if (label.startsWith('(') ||
        RegExp(
          r'\b(1d|7d|24h|30d|90d|ytd|1y)\b',
          caseSensitive: false,
        ).hasMatch(lc)) {
      continue;
    }
    label = label.replaceAll(RegExp(r'[-–:]+$'), '').trim();
    label = label[0].toUpperCase() + label.substring(1);
    final color = distributionPalette[i % distributionPalette.length];
    final isStaking =
        label.toLowerCase().contains('staking') &&
        label.toLowerCase().contains('reward');
    final legendText = isStaking
        ? 'Staking rewards - ${pct.toStringAsFixed(0)}%'
        : '$label – ${pct.toStringAsFixed(2)}%';
    slices.add(
      PieSlice(
        value: double.parse(pct.toStringAsFixed(2)),
        color: color,
        title: '${pct.toStringAsFixed(0)}%',
        legend: legendText,
      ),
    );
  }
  return slices.isEmpty ? null : slices;
}
