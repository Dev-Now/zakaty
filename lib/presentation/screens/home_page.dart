import 'package:flutter/material.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/presentation/widgets/calculation_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ZakatCalculation> _calculationInstances = [];
  int _selectedCalculationInstance = 0;
  late CalculationSheet _selectedCalculationSheet;
  final ZakatCalculation _exploreCalculationInstance = ZakatCalculation(title: 'Exploration sheet');

  void _setSelectedCalculationSheet(int selected) {
    setState(() {
      _selectedCalculationInstance = selected;
      if(selected >= 1 && (selected - 1) < _calculationInstances.length) {
        _selectedCalculationSheet = CalculationSheet(
          key: ValueKey(DateTime.now()),
          calculationInstance: _calculationInstances[selected - 1]
        );
      } else {
        _selectedCalculationSheet = CalculationSheet(
          key: ValueKey(DateTime.now()),
          calculationInstance: _exploreCalculationInstance
        );
      }
    });
  }

  void _addNewCalculationSheet() {
    setState(() {
      final newIndex = _calculationInstances.length + 1;
      final calculationInstance = ZakatCalculation(
        title: 'ZAKAT $newIndex'
      );
      _calculationInstances.add(calculationInstance);
      _selectedCalculationInstance = newIndex;
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: calculationInstance);
    });
  }

  void _copyCalculationSheet() {
    setState(() {
      final newIndex = _calculationInstances.length + 1;
      final selectedCalculationInstance = _selectedCalculationSheet.calculationInstance;
      final copyInstance = ZakatCalculation(
        title: '${selectedCalculationInstance.title} - COPY',
        currency: selectedCalculationInstance.currency,
      );
      copyInstance.addAmounts(selectedCalculationInstance.copyAmounts());
      _calculationInstances.add(copyInstance);
      _selectedCalculationInstance = newIndex;
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: copyInstance,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCalculationSheet = CalculationSheet(
      calculationInstance: _exploreCalculationInstance
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        foregroundColor: theme.colorScheme.primary,
        title: Text(
          'Zakat Calculator',
          style: TextStyle(fontWeight: FontWeight.bold)
          ),
      ),

      body: Row(
        children: [
          SizedBox(
            width: 350,
            child: ListView.builder(
              itemCount: _calculationInstances.length + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(index == 0 ? Icons.query_stats : Icons.calculate),
                  title: Text(index == 0 ? _exploreCalculationInstance.title : _calculationInstances[index - 1].title),
                  selected: _selectedCalculationInstance == index,
                  iconColor: theme.colorScheme.inversePrimary,
                  textColor: theme.colorScheme.inversePrimary,
                  tileColor: theme.colorScheme.surfaceContainer,
                  selectedColor: theme.colorScheme.onPrimaryContainer,
                  selectedTileColor: theme.colorScheme.primaryContainer,
                  onTap: () => _setSelectedCalculationSheet(index),
                );
              },
            ),
          ),
          Expanded(
            child: _selectedCalculationSheet,
          ),
        ],
      ),
      
      bottomNavigationBar: BottomAppBar(
        color: theme.colorScheme.surfaceContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {}, // !!!TODO...
              tooltip: 'Configure current calculation sheet',
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton(
              onPressed: () {}, // !!!TODO...
              tooltip: 'Delete current calculation sheet',
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              onPressed: _copyCalculationSheet,
              tooltip: 'Copy current calculation sheet',
              icon: const Icon(Icons.copy_outlined),
            ),
            IconButton(
              onPressed: _addNewCalculationSheet,
              tooltip: 'Add new calculation sheet',
              icon: const Icon(Icons.add_chart_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
