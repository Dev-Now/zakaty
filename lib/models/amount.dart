enum AmountType { saving, advancedZakatPortion }

class Amount {
  final String name;
  final AmountType type;
  final double value;
  final bool includedInSavings;
  final String currency;

  Amount({
    required this.name,
    this.value = 0,
    this.type = AmountType.saving,
    this.includedInSavings = true,
    this.currency = 'TND',
  });

  String getFullTypeName() {
    return type == AmountType.saving
      ? "Savings"
      : "Advanced Zakat";
  }

  bool isSaving() {
    return type == AmountType.saving || includedInSavings;
  }
}
