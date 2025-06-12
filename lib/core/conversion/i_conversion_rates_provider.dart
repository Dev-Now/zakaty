abstract class IConversionRatesProvider {
  Future<Map<String, double>> getConversionRates(
    String targetCurrency,
    DateTime targetDate,
  );
}