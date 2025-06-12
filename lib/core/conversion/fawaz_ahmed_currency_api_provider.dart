import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zakaty/config.dart';
import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';
import 'package:zakaty/utils/logger.dart';

class FawazAhmedCurrencyApiProvider implements IConversionRatesProvider {
  final String _providerBaseUrl;

  FawazAhmedCurrencyApiProvider({required String providerBaseUrl}) : _providerBaseUrl = providerBaseUrl;

  @override
  Future<Map<String, double>> getConversionRates(String targetCurrency, DateTime targetDate) async {
    final String dateStr = targetDate.isBefore(DateTime.now())
      ? targetDate.toIso8601String().split('T').first
      : 'latest';
    
    final String currencyStr = targetCurrency.toLowerCase();

    final String url = _providerBaseUrl
      .replaceAll(RegExp(r'\{date\}'), dateStr)
      .replaceAll(RegExp(r'\{target\}'), currencyStr);

    final result = <String, double>{};
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data[currencyStr] as Map<String, dynamic>;
        for (var supportedCurrency in AppConfig.currencyOptions) {
          final key = supportedCurrency.toLowerCase();
          if (rates.containsKey(key)) {
            result[supportedCurrency] = (rates[key] as num).toDouble();
          }
        }
      } else {
        logger.severe('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.severe('Error fetching data: $e');
    }

    return result;
  }
}