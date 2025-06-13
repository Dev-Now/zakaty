class AppConfig {
  static const List<String> currencyOptions = ["TND", "USD", "EUR", "CAD", "SAR"];
  static const String fawazAhmedCurrencyApiProvider = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@{date}/v1/currencies/{target}.json";
  static const String fawazAhmedCurrencyFallbackApiProvider = "https://{date}.currency-api.pages.dev/v1/currencies/{target}.json";
  static const String openERCurrencyApiProvider = "https://open.er-api.com/v6/latest/{target}";
  static const String workingDirectory = "C:\\Users\\majdo\\Dropbox\\Mech\\Budget\\Zakat";
  static const int maxNbOfSavedLogs = 1000;
}