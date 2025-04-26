enum AmountType { saving, advancedZakatPortion }

class Amount {
  final String name;
  final AmountType type;
  final double value;
  final bool includedInSavings;
  final String currency;

  Amount({
    required this.name,
    this.value = 0.0,
    this.type = AmountType.saving,
    this.includedInSavings = true,
    this.currency = 'TND',
  });

  static String fullTypeName(AmountType type) {
    return type == AmountType.saving
      ? "Savings"
      : "Advanced Zakat";
  }

  String getFullTypeName() {
    return fullTypeName(type);
  }

  bool isSaving() {
    return type == AmountType.saving || includedInSavings;
  }

  Amount copyWith({String? name, AmountType? type, double? value, bool? includedInSavings, String? currency}) {
    return Amount(
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      includedInSavings: includedInSavings ?? this.includedInSavings,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString(),
      'value': value,
      'includedInSavings': includedInSavings,
      'currency': currency,
    };
  }

  static Amount fromJson(Map<String, dynamic> json) {
    return Amount(
      name: json['name'],
      type: _amountTypeFromString(json['type']),
      value: (json['value'] as num).toDouble(),
      includedInSavings: json['includedInSavings'] ?? true,
      currency: json['currency'],
    );
  }
}

// Helper function for parsing AmountType enum
AmountType _amountTypeFromString(String typeString) {
  switch (typeString) {
    case 'AmountType.saving':
      return AmountType.saving;
    case 'AmountType.advancedZakatPortion':
      return AmountType.advancedZakatPortion;
    default:
      return AmountType.saving;
  }
}
