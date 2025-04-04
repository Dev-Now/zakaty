import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakaty/config.dart';
import '../../models/amount.dart';

class AmountWidget extends StatefulWidget {
  final Amount amount;
  final void Function(Amount) onEditAmount;
  final void Function(bool) onToggleIncludedInSavings;
  final void Function() onDelete;

  const AmountWidget({
    super.key,
    required this.amount,
    required this.onEditAmount,
    required this.onToggleIncludedInSavings,
    required this.onDelete,
  });

  @override
  State<AmountWidget> createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
  void _showEditDialog() {
    final editedAmount = widget.amount;
    final TextEditingController nameCtrl = TextEditingController(text: editedAmount.name);
    AmountType selectedType = editedAmount.type;
    final TextEditingController valueCtrl = TextEditingController(text: editedAmount.value.toString());
    String selectedCurrency = editedAmount.currency;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Configure amount"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: "Edit name"),
              ),
              DropdownButtonFormField<AmountType>(
                value: selectedType,
                onChanged: (newValue) {
                  selectedType = newValue!;
                },
                items: AmountType.values.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(Amount.fullTypeName(option)),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: "Select type"),
              ),
              TextField(
                controller: valueCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                decoration: InputDecoration(labelText: "Edit value"),
              ),
              DropdownButtonFormField(
                value: selectedCurrency,
                onChanged: (newValue) {
                  selectedCurrency = newValue!;
                },
                items: AppConfig.currencyOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: "Select currency"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateAmount(Amount(
                  name: nameCtrl.text,
                  type: selectedType,
                  value: double.parse(valueCtrl.text),
                  currency: selectedCurrency,
                  includedInSavings: widget.amount.includedInSavings,
                ));
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _updateAmount(Amount newAmount) {
    widget.onEditAmount(newAmount);
  }
  
  void _toggleIncludedInSavings(bool value) {
    widget.onToggleIncludedInSavings(value);
  }

  void _deleteYourself() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final textColor = widget.amount.isSaving() ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onErrorContainer;
    final styleName = theme.textTheme.titleLarge!.copyWith(color: textColor);
    final styleType = theme.textTheme.labelLarge!.copyWith(color: textColor, fontWeight: FontWeight.bold);
    final styleValue = theme.textTheme.headlineLarge!.copyWith(color: textColor);
    final styleCurrency = theme.textTheme.labelLarge!.copyWith(color: textColor, fontStyle: FontStyle.italic);

    return Card(
      color: widget.amount.isSaving() ? theme.colorScheme.primaryContainer : theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.amount.name} ', style: styleName,),
                  Text('(${widget.amount.getFullTypeName()})', style: styleType),
                  Text(' : ', style: styleName),
                  Text('${widget.amount.value} ', style: styleValue),
                  Text(widget.amount.currency, style: styleCurrency),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: widget.amount.type == AmountType.advancedZakatPortion,
                    child: Tooltip(
                      message: widget.amount.includedInSavings ? "Exclude from savings" : "Include in savings",
                      child: Switch(
                        value: widget.amount.includedInSavings,
                        onChanged: _toggleIncludedInSavings,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton.outlined(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: _deleteYourself,
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
