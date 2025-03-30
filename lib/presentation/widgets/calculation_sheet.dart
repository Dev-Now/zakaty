import 'package:flutter/material.dart';
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

    var defaultColWidth = 300.0;
    var typeColWidth = 100.0;
    var currencyColWidth = 60.0;
    var includedColWidth = 60.0;
    var editColWidth = 50.0;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.surfaceBright,
        title: Text(widget.title),
      ),

      body: Column(
        children: [
          // scrollable list of amounts
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: defaultColWidth,
                        child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: typeColWidth,
                        child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: defaultColWidth,
                        child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: currencyColWidth,
                        child: Text("Currency", style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: includedColWidth,
                        child: Text("Included", style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: editColWidth,
                        child: Center(child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold)))
                      )
                    ),
                  ],
                  rows: [
                    for (var amount in _amounts)
                      DataRow(cells: [
                        DataCell(Text(amount.name)),
                        DataCell(Text(amount.getFullTypeName())),
                        DataCell(Text('${amount.value}')),
                        DataCell(Center(child: Text(amount.currency))),
                        DataCell(Center(child: Text(amount.isSaving() ? 'X' : ''))),
                        DataCell(
                          Center(
                            child: ElevatedButton(
                              onPressed: _showAmountEditDialog,
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
            ),
          ),

          // Fixed footer
          // Container(
          //   padding: const EdgeInsets.all(25.0),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     border: const Border(top: BorderSide(color: Colors.black, width: 1)),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text("Total Savings:", style: TextStyle(fontWeight: FontWeight.bold)),
          //           Text("$_totalSavings TND"),
          //         ],
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text("Zakat (2.5%):", style: TextStyle(fontWeight: FontWeight.bold)),
          //           Text("$_zakat TND"),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
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
