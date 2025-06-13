import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zakaty/config.dart';
import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';
import 'package:zakaty/utils/logger.dart';

class OpenERCurrencyApiProvider implements IConversionRatesProvider {
  @override
  Future<Map<String, double>> getConversionRates(String targetCurrency, DateTime targetDate) async {
    if (targetDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) return {};
    
    final String currencyStr = targetCurrency.toUpperCase();

    final String url = AppConfig.openERCurrencyApiProvider
      .replaceAll(RegExp(r'\{target\}'), currencyStr);

    final result = <String, double>{};
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data["rates"] as Map<String, dynamic>;
        for (var supportedCurrency in AppConfig.currencyOptions) {
          if (rates.containsKey(supportedCurrency)) {
            result[supportedCurrency] = (rates[supportedCurrency] as num).toDouble();
          }
        }
      } else {
        logger.severe('OpenERCurrencyApiProvider >> Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.severe('OpenERCurrencyApiProvider >> Error fetching data: $e');
    }

    return result;
  }
}