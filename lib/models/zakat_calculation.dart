import 'package:zakaty/core/conversion_rates.dart';
import 'package:zakaty/models/amount.dart';

class ZakatCalculation {
  final String title;
  final String currency;
  final DateTime? dueDate;
  final List<Amount> amounts = [];
  
  double _totalSavings = 0.0;
  double _zakat = 0.0;
  double _zakatToDo = 0.0;

  ZakatCalculation({
    required this.title,
    this.currency = 'TND',
    this.dueDate,
  });

  Future<void> _computeZakat() async {
    // get currency conversion rates to this.currency
    final conversionRates = await ConversionRatesService.getConversionRates(currency, dueDate ?? DateTime.now());

    // refresh savings
    _refreshTotalSavings(conversionRates);
    
    // compute zakat
    _zakat = _totalSavings / 40;
    
    double allAdvanced = 0.0;
    for (var adv in amounts.where((amount) => amount.type == AmountType.advancedZakatPortion)) {
      allAdvanced += _convertAmountToCalculationCurrency(adv, conversionRates);
    }

    _zakatToDo = _zakat - allAdvanced;
  }

  void _refreshTotalSavings(Map<String, double> conversionRates) {
    _totalSavings = 0.0;
    for (var amount in amounts) {
      if (amount.isSaving()) {
        _totalSavings += _convertAmountToCalculationCurrency(amount, conversionRates);
      }
    }
  }

  double _convertAmountToCalculationCurrency(Amount amount, Map<String, double> conversionRates) {
    return amount.currency == currency
      ? amount.value
      : (1 / conversionRates[amount.currency]!) * amount.value;
  }

  void addAmount(Amount amount) {
    amounts.add(amount);
  }

  void addAmounts(List<Amount> amountsToAdd) {
    for (var amount in amountsToAdd) {
      addAmount(amount);
    }
  }

  List<Amount> copyAmounts() {
    return amounts.map((amount) => amount.copyWith()).toList();
  }

  Future<String> getCalculationSummary() async {
    await _computeZakat();
    return '$title : Savings = ${_totalSavings.toStringAsFixed(3)} $currency, Zakat = ${_zakat.toStringAsFixed(3)} $currency, ToDo = ${_zakatToDo.toStringAsFixed(3)} $currency';
  }

  void setIncludeAmountInSavings(int index, bool isIncluded) {
    amounts[index] = Amount(
        name: amounts[index].name,
        value: amounts[index].value,
        type: amounts[index].type,
        includedInSavings: isIncluded,
        currency: amounts[index].currency,
    );
  }
}