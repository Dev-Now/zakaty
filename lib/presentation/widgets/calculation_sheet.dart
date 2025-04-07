import 'package:flutter/material.dart';
import 'package:zakaty/models/amount.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/presentation/widgets/amount_widget.dart';

class CalculationSheet extends StatefulWidget {
  final ZakatCalculation calculationInstance;
  const CalculationSheet({super.key, required this.calculationInstance});

  @override
  State<CalculationSheet> createState() => _CalculationSheetState();
}

class _CalculationSheetState extends State<CalculationSheet> {
  late ZakatCalculation _zakatCalculation;
  late String _zakatSummary;

  @override
  void initState() {
    super.initState();
    _zakatCalculation = widget.calculationInstance;
    _zakatSummary = "${widget.calculationInstance.title} : Loading. . .";
    
    Future.delayed(Duration.zero, _initialize);
  }

  void _initialize() async {
    final zakatSummary = await _zakatCalculation.getCalculationSummary();
    setState(() {
      _zakatSummary = zakatSummary;
    });
  }

  void _addAmount() async {
    _zakatCalculation.addAmount(
      Amount(
        name: 'Saving ${_zakatCalculation.amounts.length + 1}',
        currency: _zakatCalculation.currency,
      )
    );
    final zakatSummary = await _zakatCalculation.getCalculationSummary();
    setState(() {
      _zakatSummary = zakatSummary;
    });
  }

  void _updateAmount(int index, Amount newAmount) async {
    _zakatCalculation.amounts[index] = newAmount;
    final zakatSummary = await _zakatCalculation.getCalculationSummary();
    setState(() {
      _zakatSummary = zakatSummary;
    });
  }

  void _includeAmountInSavings(int index, bool isIncluded) async {
    _zakatCalculation.setIncludeAmountInSavings(index, isIncluded);
    final zakatSummary = await _zakatCalculation.getCalculationSummary();
    setState(() {
      _zakatSummary = zakatSummary;
    });
  }

  void _deleteAmount(int index) async {
    _zakatCalculation.amounts.removeAt(index);
    final zakatSummary = await _zakatCalculation.getCalculationSummary();
    setState(() {
      _zakatSummary = zakatSummary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,

      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        title: Tooltip(message: _zakatSummary, child: Text(_zakatSummary)),
      ),

      body: ListView.builder(
        itemCount: _zakatCalculation.amounts.length,
        itemBuilder: (context, index) {
          return AmountWidget(
              amount: _zakatCalculation.amounts[index],
              onEditAmount: (newAmount) => _updateAmount(index, newAmount),
              onToggleIncludedInSavings: (isIncluded) => _includeAmountInSavings(index, isIncluded),
              onDelete: () => _deleteAmount(index),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: _addAmount,
          tooltip: 'Add new amount',
          backgroundColor: theme.colorScheme.tertiary,
          foregroundColor: theme.colorScheme.onTertiary,
          child: const Icon(Icons.add),
        ),
    );
  }
}
