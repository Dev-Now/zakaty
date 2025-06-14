import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';
import 'package:zakaty/utils/get_cache_file_path.dart';
import 'package:zakaty/utils/logger.dart';

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

  Future<void> saveToDisk() async {
    final filePath = await getCacheFilePath();
    final file = File(filePath);
    final jsonMap = _cache.map((target, tree) => MapEntry(
      target,
      tree.map((date, rates) => MapEntry(date.toIso8601String().split('T').first, rates)),
    ));
    await file.writeAsString(jsonEncode(jsonMap));
  }

  Future<void> loadFromDisk() async {
    final filePath = await getCacheFilePath();
    final file = File(filePath);
    if (!(await file.exists())) return;

    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      for (final target in decoded.keys) {
        final tree = SplayTreeMap<DateTime, Map<String, double>>();
        final dateMap = decoded[target] as Map<String, dynamic>;
        for (final dateStr in dateMap.keys) {
          final date = DateTime.parse(dateStr);
          final ratesMap = Map<String, double>.from(
            (dateMap[dateStr] as Map).map((k, v) => MapEntry(k, (v as num).toDouble()))
          );
          tree[date] = ratesMap;
        }
        _cache[target] = tree;
      }
    } catch (e) {
      logger.warning('Error loading cached rates from disk: $e');
    }
  }
}