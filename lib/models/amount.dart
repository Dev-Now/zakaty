enum AmountType { saving, advancedZakatPortion }

class Amount {
  final AmountType type;
  final double value;
  final bool includedInSavings;
  final String currency;

  Amount({
    required this.value,
    this.type = AmountType.saving,
    this.includedInSavings = true,
    this.currency = 'TND',
  });
}
