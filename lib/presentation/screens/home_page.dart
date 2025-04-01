import 'package:flutter/material.dart';
import 'package:zakaty/presentation/widgets/calculation_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addNewCalculationSheet() {
    // !!!TODO...
  }

  void _copyCalculationSheet() {
    // !!!TODO...
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

      body: CalculationSheet(),
      
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
