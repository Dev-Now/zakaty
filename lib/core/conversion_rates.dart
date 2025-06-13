import 'package:zakaty/config.dart';
import 'package:zakaty/core/conversion/cache_currency_provider.dart';
import 'package:zakaty/core/conversion/fawaz_ahmed_currency_api_provider.dart';
import 'package:zakaty/core/conversion/i_conversion_rates_provider.dart';
import 'package:zakaty/core/conversion/open_er_currency_api_provider.dart';
import 'package:zakaty/utils/logger.dart';

class ConversionRatesService {
  static final CachedRatesProvider _cacheProvider = CachedRatesProvider();

  static final List<IConversionRatesProvider> _providers = [
    FawazAhmedCurrencyApiProvider(providerBaseUrl: AppConfig.fawazAhmedCurrencyApiProvider),
    FawazAhmedCurrencyApiProvider(providerBaseUrl: AppConfig.fawazAhmedCurrencyFallbackApiProvider),
    OpenERCurrencyApiProvider(),
    _cacheProvider,
  ];

  static Future<Map<String, double>> getConversionRates(String targetCurrency, DateTime targetDate) async {
    final cachedRates = await _cacheProvider.getConversionRates(targetCurrency, targetDate);

    var conversionRates = <String, double>{};
    
    for(final entry in _providers.asMap().entries) {
      final providerNdx = entry.key + 1;
      final provider = entry.value;
      conversionRates = await provider.getConversionRates(targetCurrency, targetDate);

      if (_tryCoverAllCurrencyOptions(
        targetCurrency,
        targetDate,
        conversionRates,
        provider,
        cachedRates
      )) {
        break;
      } else {
        logger.warning('Conversion rates provider $providerNdx failed; System is going to try the next.');
      }
    }

    return conversionRates;
  }

  static bool _tryCoverAllCurrencyOptions(
    String targetCurrency,
    DateTime targetDate,
    Map<String, double> rates,
    IConversionRatesProvider provider,
    Map<String, double> cachedRates,
  ) {
    if (provider != _cacheProvider && rates.isEmpty) return false;

    for (var supportedCurrency in AppConfig.currencyOptions) {
      if (provider != _cacheProvider && rates.containsKey(supportedCurrency)) {
        _cacheProvider.addToCache(
          targetCurrency: targetCurrency,
          date: targetDate,
          convertedCurrency: supportedCurrency,
          rate: rates[supportedCurrency]!,
        );
      } else if (!rates.containsKey(supportedCurrency)) {
        if (!cachedRates.containsKey(supportedCurrency)) {
          logger.warning('No cached conversion from $targetCurrency to $supportedCurrency. Default rate 1.0 will be used!');
        }
        rates[supportedCurrency] = cachedRates[supportedCurrency] ?? 1.0;
      }
    }

    return true;
  }
}