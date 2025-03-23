import 'package:flutter/material.dart';
import '../../models/amount.dart';
import '../widgets/amount_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Amount> _amounts = [];

  double _zakat = 0;
  double _totalSavings = 0;

  void _calculateZakat() {
    _totalSavings = 0;
    for (var amount in _amounts) {
      if (amount.type == AmountType.saving || amount.includedInSavings) {
        _totalSavings += amount.value;
      }
    }
    _zakat = _totalSavings / 40;
  }

  void _addAmount() {
    setState(() {
      _amounts.add(Amount(value: 10));
      _calculateZakat();
    });
  }

  void _updateAmount(int index, bool isIncluded) {
    setState(() {
      _amounts[index] = Amount(
        value: _amounts[index].value,
        type: _amounts[index].type,
        includedInSavings: isIncluded,
        currency: _amounts[index].currency,
      );
      _calculateZakat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // table headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Currency", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Included", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // scrollable list of amounts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: _amounts.length,
                itemBuilder: (context, index) {
                  return AmountWidget(
                        amount: _amounts[index],
                        onToggleIncludedInSavings: (isIncluded) => _updateAmount(index, isIncluded),
                    );
                },
              ),
            ),
          ),

          // Fixed footer
          Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(top: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Savings:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$_totalSavings TND"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Zakat (2.5%):", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$_zakat TND"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAmount,
        tooltip: 'Add new amount',
        child: const Icon(Icons.add),
      ),
    );
  }
}
