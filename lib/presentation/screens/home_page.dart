import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zakaty/config.dart';
import 'package:zakaty/core/calculations_storage.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/presentation/widgets/calculation_sheet.dart';
import 'package:zakaty/presentation/widgets/date_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appStatusMessage = '';
  final List<ZakatCalculation> _calculationInstances = [];
  int _selectedCalculationInstance = 0;
  late CalculationSheet _selectedCalculationSheet;
  ZakatCalculation _exploreCalculationInstance = ZakatCalculation(title: 'Exploration sheet');

  void _showEditDialog() {
    final selectedCalculationInstance = _selectedCalculationSheet.calculationInstance;
    final TextEditingController controller = TextEditingController(text: selectedCalculationInstance.title);
    String selectedCurrency = selectedCalculationInstance.currency;
    DateTime selectedDueDate = selectedCalculationInstance.dueDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Configure calculation sheet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Edit title"),
              ),
              DropdownButtonFormField(
                value: selectedCurrency,
                onChanged: (newValue) {
                  selectedCurrency = newValue!;
                },
                items: AppConfig.currencyOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: "Select currency"),
              ),
              DatePicker(
                label: "Zakat due on",
                initialDate: selectedDueDate,
                onDatePicked: (picked) {
                  selectedDueDate = picked;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateSelectedCalculation(controller.text, selectedCurrency, selectedDueDate);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _updateSelectedCalculation(String newTitle, String newCurrency, DateTime newDueDate) {
    setState(() {
      if (_selectedCalculationInstance == 0) {
        final amountsCopy = _exploreCalculationInstance.copyAmounts();
        _exploreCalculationInstance = ZakatCalculation(
          title: newTitle,
          currency: newCurrency,
          dueDate: newDueDate,
        );
        _exploreCalculationInstance.addAmounts(amountsCopy);
      } else {
        final amountsCopy = _calculationInstances[_selectedCalculationInstance - 1].copyAmounts();
        _calculationInstances[_selectedCalculationInstance - 1]
          = _calculationInstances[_selectedCalculationInstance - 1].editMeta(
            newTitle: newTitle,
            newCurrency: newCurrency,
            newDueDate: newDueDate,
          );
        _calculationInstances[_selectedCalculationInstance - 1].saveMe = true;
        _calculationInstances[_selectedCalculationInstance - 1].addAmounts(amountsCopy);
      }
      _setSelectedCalculationSheet(_selectedCalculationInstance);
    });
  }

  void _setSelectedCalculationSheet(int selected) {
    setState(() {
      _selectedCalculationInstance = selected;
      if(selected >= 1 && (selected - 1) < _calculationInstances.length) {
        _selectedCalculationSheet = CalculationSheet(
          key: ValueKey(DateTime.now()),
          calculationInstance: _calculationInstances[selected - 1],
          onEdited: () => _setSaveMeForSelectedCalculationSheet(true),
        );
      } else {
        _selectedCalculationSheet = CalculationSheet(
          key: ValueKey(DateTime.now()),
          calculationInstance: _exploreCalculationInstance,
          onEdited: () => { /** do nothing */ },
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
      calculationInstance.saveMe = true;
      _calculationInstances.add(calculationInstance);
      _selectedCalculationInstance = newIndex;
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: calculationInstance,
        onEdited: () => _setSaveMeForSelectedCalculationSheet(true),
      );
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
      copyInstance.saveMe = true;
      copyInstance.addAmounts(selectedCalculationInstance.copyAmounts());
      _calculationInstances.add(copyInstance);
      _selectedCalculationInstance = newIndex;
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: copyInstance,
        onEdited: () => _setSaveMeForSelectedCalculationSheet(true),
      );
    });
  }

  void _deleteCalculationSheet() {
    setState(() {
      if (_selectedCalculationInstance == 0) {
        _exploreCalculationInstance.amounts.clear();
      } else {
        _calculationInstances.removeAt(_selectedCalculationInstance - 1);
      }
      _selectedCalculationInstance = 0;
      _selectedCalculationSheet = CalculationSheet(
        key: ValueKey(DateTime.now()),
        calculationInstance: _exploreCalculationInstance,
        onEdited: () => { /** do nothing */ },
      );
    });
  }

  void _saveCalculationSheet() async {
    await ZakatCalculationsStorageService.saveZakatCalculation(_selectedCalculationSheet.calculationInstance);
    _setSaveMeForSelectedCalculationSheet(false);
  }

  void _setSaveMeForSelectedCalculationSheet(bool newState) {
    if (_selectedCalculationInstance != 0) {
      setState(() {
        _calculationInstances[_selectedCalculationInstance - 1].saveMe = newState;     
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _selectedCalculationSheet = CalculationSheet(
      calculationInstance: _exploreCalculationInstance,
      onEdited: () => { /** do nothing */ },
    );
    _appStatusMessage = 'Loading saved calculation sheets. . .';

    Future.delayed(Duration.zero, _initialize);
  }

  void _initialize() async {
    final wd = Directory(AppConfig.workingDirectory);
    final files = wd. listSync().whereType<File>().where((file) => file.path.endsWith('.json'));
    
    final savedCalculationInstances = [];

    for (var file in files) {
      try {
        savedCalculationInstances.add(
          await ZakatCalculationsStorageService.loadZakatCalculation(file)
        );
      } catch(e) {
        // !!!TODO... log the exception here
      }
    }

    setState(() {
      for(final calc in savedCalculationInstances) {
        _calculationInstances.add(calc);
      }
      _appStatusMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        foregroundColor: theme.colorScheme.primary,
        title: Text(
          'Zakat Calculator ${(_appStatusMessage.isEmpty ? '' : ' - $_appStatusMessage')}',
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
                final calcInstance = index == 0 ? _exploreCalculationInstance : _calculationInstances[index - 1];

                return ListTile(
                  leading: Icon(index == 0 ? Icons.query_stats : Icons.calculate),
                  title: Text(calcInstance.title),
                  trailing: Visibility(
                    visible: index != 0,
                    child: Icon(
                      Icons.save,
                      color: calcInstance.saveMe ? theme.colorScheme.error : theme.colorScheme.primary,
                    ),
                  ),
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
              onPressed: _showEditDialog,
              tooltip: 'Configure current calculation sheet',
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton(
              onPressed: _deleteCalculationSheet,
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
            IconButton(
              onPressed: _saveCalculationSheet,
              tooltip: 'Save current calculation sheet',
              icon: const Icon(Icons.save_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
