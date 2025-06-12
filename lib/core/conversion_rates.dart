import 'package:zakaty/config.dart';
import 'package:zakaty/core/conversion/fawaz_ahmed_currency_api_provider.dart';
import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';
import 'package:zakaty/utils/logger.dart';

class ConversionRatesService {
  static final List<IConversionRatesProvider> _providers = [
    FawazAhmedCurrencyApiProvider(providerBaseUrl: AppConfig.fawazAhmedCurrencyApiProvider),
    FawazAhmedCurrencyApiProvider(providerBaseUrl: AppConfig.fawazAhmedCurrencyFallbackApiProvider),
    // !!!TODO... third provider,
    // !!!TODO... stored hardcoded rates provider that never fails,
  ];

  static Future<Map<String, double>> getConversionRates(String targetCurrency, DateTime targetDate) async {
    var conversionRates = <String, double>{};
    
    var providerNdx = 1;
    for(final provider in _providers) {
      conversionRates = await provider.getConversionRates(targetCurrency, targetDate);

      if (_tryCoverAllCurrencyOptions(conversionRates)) {
        break;
      } else {
        logger.warning('Conversion rates provider $providerNdx failed; System is going to try the next.');
      }

      providerNdx++;
    }

    return conversionRates;
  }

  static bool _tryCoverAllCurrencyOptions(Map<String, double> rates) {
    if (rates.isEmpty) return false;

    for (var supportedCurrency in AppConfig.currencyOptions) {
      if (rates.containsKey(supportedCurrency)) {
        // !!!TODO... add here the update of the stored conversion rates of the fallback provider that never fails
      } else {
        rates[supportedCurrency] = 1.0; // !!!TODO... later change this to use the fallback provider that never fails to get it
      }
    }

    return true;
  }
}