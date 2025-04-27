import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zakaty/config.dart';
import 'package:zakaty/core/calculations_storage.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/presentation/widgets/calculation_sheet.dart';
import 'package:zakaty/presentation/widgets/date_picker.dart';

enum ExitOption { saveAndExit, exitWithoutSaving, cancelExit }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  String _calculationsLoadingMsg = '';
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
    windowManager.addListener(this);
    _selectedCalculationSheet = CalculationSheet(
      calculationInstance: _exploreCalculationInstance,
      onEdited: () => { /** do nothing */ },
    );
    _calculationsLoadingMsg = 'Loading saved sheets. . .';

    Future.delayed(Duration.zero, _initialize);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
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
      _calculationsLoadingMsg = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var calculationsLoadingInProgress = _calculationsLoadingMsg.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        bool nothingToSave = _nothingToSave();
        final exitOption = nothingToSave
          ? ExitOption.exitWithoutSaving
          : await _showExitDialog(context) ?? ExitOption.cancelExit;
        if (exitOption == ExitOption.saveAndExit) {
          await _saveAllUnsavedCalculations();
        }
        if (context.mounted && exitOption != ExitOption.cancelExit) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                itemCount: 1 + (calculationsLoadingInProgress ? 1 : _calculationInstances.length),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: Icon(Icons.query_stats),
                      title: Text(_exploreCalculationInstance.title),
                      selected: _selectedCalculationInstance == index,
                      iconColor: theme.colorScheme.inversePrimary,
                      textColor: theme.colorScheme.inversePrimary,
                      tileColor: theme.colorScheme.surfaceContainer,
                      selectedColor: theme.colorScheme.onPrimaryContainer,
                      selectedTileColor: theme.colorScheme.primaryContainer,
                      onTap: () => _setSelectedCalculationSheet(index),
                    );
                  } else {
                    if (calculationsLoadingInProgress) {
                      return ListTile(
                        title: Text(_calculationsLoadingMsg),
                        leading: CircularProgressIndicator(),
                        textColor: theme.colorScheme.inversePrimary,
                        tileColor: theme.colorScheme.surfaceContainer,
                      );
                    } else {
                      final calcInstance = _calculationInstances[index - 1];
                      
                      return ListTile(
                        leading: Icon(Icons.calculate),
                        title: Text(calcInstance.title),
                        trailing: Icon(
                          Icons.save,
                          color: calcInstance.saveMe ? theme.colorScheme.error : theme.colorScheme.primary,
                        ),
                        selected: _selectedCalculationInstance == index,
                        iconColor: theme.colorScheme.inversePrimary,
                        textColor: theme.colorScheme.inversePrimary,
                        tileColor: theme.colorScheme.surfaceContainer,
                        selectedColor: theme.colorScheme.onPrimaryContainer,
                        selectedTileColor: theme.colorScheme.primaryContainer,
                        onTap: () => _setSelectedCalculationSheet(index),
                      );
                    }
                  }
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
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool nothingToSave = _nothingToSave();
    if (nothingToSave) {
      windowManager.destroy();
    }
    final exitOption = await _showExitDialog(context) ?? ExitOption.cancelExit;
    if (exitOption == ExitOption.saveAndExit) {
      await _saveAllUnsavedCalculations();
    }
    if (exitOption != ExitOption.cancelExit) {
      windowManager.destroy();
    }
  }

  bool _nothingToSave() {
    return _calculationInstances.every((calc) => !calc.saveMe);
  }

  Future<void> _saveAllUnsavedCalculations() async {
    for(var calcToSave in _calculationInstances.where((calc) => calc.saveMe)) {
      await ZakatCalculationsStorageService.saveZakatCalculation(calcToSave);
    }
  }

  Future<ExitOption?> _showExitDialog(BuildContext context) async {
    return showDialog<ExitOption>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsaved changes!'),
          content: const Text('You have unsaved changes. Save them all before leaving?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.pop(context, ExitOption.saveAndExit);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, ExitOption.exitWithoutSaving);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, ExitOption.cancelExit);
              },
            ),
          ]
        );
      }
    );
  }
}
