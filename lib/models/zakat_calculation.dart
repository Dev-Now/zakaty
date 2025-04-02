import 'package:zakaty/models/amount.dart';

class ZakatCalculation {
  final String title;
  final String currency;
  final List<Amount> amounts = [];
  
  double _totalSavings = 0.0;
  double _zakat = 0.0;

  ZakatCalculation({
    required this.title,
    this.currency = 'TND',
  });

  void _computeZakat() {
    _refreshTotalSavings();
    _zakat = _totalSavings / 40;
  }

  void _refreshTotalSavings() {
    _totalSavings = 0.0;
    for (var amount in amounts) {
      if (amount.isSaving()) {
        // !!!TODO... convert amount if it has different currency!
        _totalSavings += amount.value;
      }
    }
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

  String getCalculationSummary() {
    _computeZakat();
    return '$title : Savings = $_totalSavings $currency, Zakat = $_zakat $currency';
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