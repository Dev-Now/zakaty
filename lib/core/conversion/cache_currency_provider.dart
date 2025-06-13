import 'dart:collection';

import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';

class CachedRatesProvider implements IConversionRatesProvider {
  final _cache = <String, SplayTreeMap<DateTime, Map<String, double>>>{};

  void addToCache({
    required String targetCurrency,
    required DateTime date,
    required String convertedCurrency,
    required double rate,
  }) {
    final key = targetCurrency.toUpperCase();
    _cache.putIfAbsent(key, () => SplayTreeMap<DateTime, Map<String, double>>());
    _cache[key]!.putIfAbsent(date, () => {});
    _cache[key]![date]![convertedCurrency.toUpperCase()] = rate;
  }

  @override
  Future<Map<String, double>> getConversionRates(String targetCurrency, DateTime targetDate) async {
    final key = targetCurrency.toUpperCase();
    final tree = _cache[key];
    
    if (tree == null || tree.isEmpty) return {};

    final closest = _getClosestDate(tree.keys, targetDate);

    return tree[closest] ?? {};
  }

  DateTime _getClosestDate(Iterable<DateTime> dates, DateTime target) {
    return dates.reduce((a, b) =>
      (a.difference(target).abs() < b.difference(target).abs()) ? a : b);
  }
}