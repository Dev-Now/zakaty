import 'package:flutter/material.dart';
import '../../models/amount.dart';

class AmountWidget extends StatefulWidget {
  final Amount amount;
  final void Function(bool) onToggleIncludedInSavings;

  const AmountWidget({
    super.key,
    required this.amount,
    required this.onToggleIncludedInSavings,
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.amount.name),
            Text('(${widget.amount.getFullTypeName()})'),
            Text('${widget.amount.value}'),
            Text(widget.amount.currency),
            Text(widget.amount.isSaving() ? 'Included in total savings' : 'Not included in total savings'), // !!!TODO... use card background color instead!
            Visibility(
              visible: widget.amount.type == AmountType.advancedZakatPortion,
              child: Switch(
                value: _isIncludedInSavings,
                onChanged: _toggleIncludedInSavings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
