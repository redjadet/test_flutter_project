import 'dart:convert';

import 'package:complex_ui/features/dashboard/data/pie_data.dart';
import 'package:complex_ui/features/dashboard/state/token_distribution_parsers.dart'
    as parsers;
import 'package:http/http.dart' as http;

/// Fetches AVAX distribution data from a configurable JSON endpoint.
///
/// Defaults to a free CoinGecko endpoint that lists AVAX tickers across
/// exchanges, which we aggregate into a "volume share by exchange" pie chart.
/// This serves as a free, public proxy for a distribution visualization.
///
/// Override with your own endpoint via:
///   flutter run --dart-define=AVAX_DISTRIBUTION_URL=https://example.com/avax.json
/// Expected simple schema if you override:
///   [{"label":"Staking","percent":50}, ...]
///
/// If the fetch fails or is invalid, returns null so callers can gracefully
/// fall back to existing local data.
class TokenDistributionRepo {
  // Allow overriding full URL. Default to CoinMarketCap AVAX About section.
  static const _envUrl = String.fromEnvironment(
    'AVAX_DISTRIBUTION_URL',
    defaultValue: 'https://coinmarketcap.com/currencies/avalanche/#About',
  );

  /// Attempts to fetch and parse AVAX distribution slices.
  static Future<List<PieSlice>?> fetchAvaxDistribution() async {
    final primary = _envUrl.trim();
    const fallback =
        'https://api.coingecko.com/api/v3/coins/avalanche-2/tickers';

    Future<List<PieSlice>?> attempt(String url) async {
      try {
        final uri = Uri.parse(url);
        final res = await http.get(
          uri,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36',
          },
        );
        if (res.statusCode != 200) return null;
        if (uri.host.contains('coinmarketcap.com')) {
          final cmcSlices =
              parsers.extractFromCoinMarketCapAbout(res.body) ??
              parsers.extractFromCoinMarketCapHtml(res.body);
          if (cmcSlices != null && cmcSlices.isNotEmpty) return cmcSlices;
          return null;
        }
        final text = res.body.trim();
        if (text.startsWith('{') || text.startsWith('[')) {
          final body = jsonDecode(text);
          if (body is List) return parsers.mapSimpleList(body);
          if (body is Map) {
            final extracted =
                parsers.extractFromCoinGeckoTickers(body) ??
                parsers.extractDistributionFromMap(body);
            if (extracted != null) return extracted;
          }
        }
        return null;
      } catch (_) {
        return null;
      }
    }

    // Always try primary first; then fallback to CoinGecko if it fails.
    final result = (await attempt(primary)) ?? (await attempt(fallback));
    return result;
  }

  // Helper logic moved to token_distribution_parsers.dart
}
