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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.amount.getFullTypeName()),
          Text("${widget.amount.value}"),
          Text(widget.amount.currency),
          Visibility(
            visible: widget.amount.type == AmountType.advancedZakatPortion,
            child: Switch(
              value: _isIncludedInSavings,
              onChanged: _toggleIncludedInSavings,
            ),
          ),
        ],
      )
    );
  }
}
