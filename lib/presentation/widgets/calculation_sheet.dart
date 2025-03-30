import 'package:flutter/material.dart';
import 'package:zakaty/presentation/widgets/amount_widget.dart';
import '../../models/amount.dart';

class CalculationSheet extends StatefulWidget {
  final String title;
  const CalculationSheet({super.key, required this.title});

  @override
  State<CalculationSheet> createState() => _CalculationSheetState();
}

class _CalculationSheetState extends State<CalculationSheet> {
  final List<Amount> _amounts = [];

  double _zakat = 0;
  double _totalSavings = 0;

  void _calculateZakat() {
    _totalSavings = 0;
    for (var amount in _amounts) {
      if (amount.isSaving()) {
        _totalSavings += amount.value;
      }
    }
    _zakat = _totalSavings / 40;
  }

  void _addAmount() {
    setState(() {
      _amounts.add(Amount(name: 'Saving ${_amounts.length}'));
      _calculateZakat();
    });
  }

  void _updateAmount(int index, bool isIncluded) {
    setState(() {
      _amounts[index] = Amount(
        name: _amounts[index].name,
        value: _amounts[index].value,
        type: _amounts[index].type,
        includedInSavings: isIncluded,
        currency: _amounts[index].currency,
      );
      _calculateZakat();
    });
  }

  void _showAmountEditDialog() {
    // !!!TODO...
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.surfaceBright,
        title: Text(widget.title),
      ),

      body: ListView.builder(
        itemCount: _amounts.length,
        itemBuilder: (context, index) {
          return AmountWidget(
                amount: _amounts[index],
                onToggleIncludedInSavings: (isIncluded) => _updateAmount(index, isIncluded),
            );
        },
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: _addAmount,
          tooltip: 'Add new amount',
          backgroundColor: theme.colorScheme.tertiary,
          foregroundColor: theme.colorScheme.surfaceBright,
          child: const Icon(Icons.add),
        ),
    );
  }
}
