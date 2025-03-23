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
      body: 
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
          // const Text('Your total year savings:'),
          // Text(
          //   '$_totalSavings',
          //   style: Theme.of(context).textTheme.headlineMedium,
          // ),
          // const Text('Your zakat:'),
          // Text(
          //   '$_zakat',
          //   style: Theme.of(context).textTheme.headlineMedium,
          // ),
        //],
          Padding(
            padding: const EdgeInsets.all(8.0),
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
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAmount,
        tooltip: 'Add new amount',
        child: const Icon(Icons.add),
      ),
    );
  }
}
