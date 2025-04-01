import 'package:flutter/material.dart';
import 'package:zakaty/models/amount.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/presentation/widgets/amount_widget.dart';

class CalculationSheet extends StatefulWidget {
  const CalculationSheet({super.key});

  @override
  State<CalculationSheet> createState() => _CalculationSheetState();
}

class _CalculationSheetState extends State<CalculationSheet> {
  final ZakatCalculation _zakatCalculation = ZakatCalculation(
    title: '28 Shawal 1445 - 1446',
    currency: 'TND',
  );

  late String _zakatSummary;

  @override
  void initState() {
    super.initState();
    _zakatSummary = _zakatCalculation.getCalculationSummary();
  }

  void _addAmount() {
    setState(() {
      _zakatCalculation.addAmount(
        Amount(name: 'Saving ${_zakatCalculation.amounts.length + 1}')
      );
      _zakatSummary = _zakatCalculation.getCalculationSummary();
    });
  }

  void _updateAmount(int index, bool isIncluded) {
    setState(() {
      _zakatCalculation.setIncludeAmountInSavings(index, isIncluded);
      _zakatSummary = _zakatCalculation.getCalculationSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        title: Text(_zakatSummary),
      ),

      body: ListView.builder(
        itemCount: _zakatCalculation.amounts.length,
        itemBuilder: (context, index) {
          return AmountWidget(
                amount: _zakatCalculation.amounts[index],
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
