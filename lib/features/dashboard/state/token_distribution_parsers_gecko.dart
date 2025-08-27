import 'package:complex_ui/features/dashboard/data/pie_data.dart';

import 'package:complex_ui/features/dashboard/state/token_distribution_parsers_common.dart';

List<PieSlice>? extractFromCoinGeckoTickers(Map body) {
  final tickers = body['tickers'];
  if (tickers is! List) return null;

  final Map<String, double> volumeByExchange = {};
  for (final t in tickers) {
    if (t is! Map) continue;
    final market = (t['market'] as Map?)?['name'] as String?;
    final conv = t['converted_volume'];
    double? vol;
    if (conv is Map && conv['usd'] is num) {
      vol = (conv['usd'] as num).toDouble();
    } else if (t['volume'] is num) {
      vol = (t['volume'] as num).toDouble();
    }
    if (market == null || vol == null) continue;
    volumeByExchange.update(market, (v) => v + vol!, ifAbsent: () => vol!);
  }
  if (volumeByExchange.isEmpty) return null;

  final entries = volumeByExchange.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top = entries.take(8).toList();
  final others = entries.skip(8);
  final total = entries.fold<double>(0, (a, b) => a + b.value);
  if (total <= 0) return null;

  final List<MapEntry<String, double>> finalEntries = [...top];
  final othersSum = others.fold<double>(0, (a, b) => a + b.value);
  if (othersSum > 0) finalEntries.add(MapEntry('Others', othersSum));

  final slices = <PieSlice>[];
  for (var i = 0; i < finalEntries.length; i++) {
    final label = finalEntries[i].key;
    final share = (finalEntries[i].value / total) * 100.0;
    final color = distributionPalette[i % distributionPalette.length];
    slices.add(
      PieSlice(
        value: double.parse(share.toStringAsFixed(2)),
        color: color,
        title: '${share.toStringAsFixed(0)}%',
        legend: '$label – ${share.toStringAsFixed(1)}%',
      ),
    );
  }
  return slices.isEmpty ? null : slices;
}
