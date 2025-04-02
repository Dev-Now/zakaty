import 'package:flutter/material.dart';
import '../../models/amount.dart';

class AmountWidget extends StatefulWidget {
  final Amount amount;
  final void Function(bool) onToggleIncludedInSavings;
  final void Function() onDelete;

  const AmountWidget({
    super.key,
    required this.amount,
    required this.onToggleIncludedInSavings,
    required this.onDelete,
  });

  @override
  State<AmountWidget> createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
  bool _isIncludedInSavings = true;

  @override
  void initState() {
    super.initState();
    _isIncludedInSavings = widget.amount.includedInSavings;
  }

  void _toggleIncludedInSavings(bool value) {
    setState(() {
      _isIncludedInSavings = value;
    });
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
                    child: Switch(
                      value: _isIncludedInSavings,
                      onChanged: _toggleIncludedInSavings,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton.outlined(
                      onPressed: () {}, // !!!TODO... 
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
