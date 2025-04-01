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

  void _addNewCalculationSheet() {
    setState(() {
      final newIndex = _calculationInstances.length + 1;
      final calculationInstance = ZakatCalculation(
        title: 'ZAKAT $newIndex'
      );
      _selectedCalculationInstance = newIndex;
      _calculationInstances.add(calculationInstance);
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: calculationInstance);
    });
  }

  void _copyCalculationSheet() {
    // !!!TODO...
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
          SafeArea(
            child: NavigationRail(
              backgroundColor: theme.colorScheme.surfaceContainer,
              extended: true,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.query_stats),
                  label: Text('Exploration sheet')
                ),
                for (var calculationInstance in _calculationInstances)
                  NavigationRailDestination(
                    icon: Icon(Icons.calculate),
                    label: Text(calculationInstance.title),
                  ),
              ],
              selectedIndex: _selectedCalculationInstance,
              onDestinationSelected: (value) {
                setState(() {
                  _selectedCalculationInstance = value;
                  if(value >= 1 && (value - 1) < _calculationInstances.length) {
                    _selectedCalculationSheet = CalculationSheet(
                      key: ValueKey(DateTime.now()),
                      calculationInstance: _calculationInstances[value - 1]
                    );
                  } else {
                    _selectedCalculationSheet = CalculationSheet(
                      key: ValueKey(DateTime.now()),
                      calculationInstance: _exploreCalculationInstance
                    );
                  }
                });
              },
            ),
          ),
          Expanded(
            child: _selectedCalculationSheet,
          ),
        ],
      ),
      
      persistentFooterButtons: [
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
    );
  }
}
