import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDatePicked;

  const DatePicker({
    super.key,
    required this.label,
    required this.onDatePicked,
    this.initialDate,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late TextEditingController _controller;
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _pickedDate != null ? _formatDate(_pickedDate!) : '',
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _pickedDate = picked;
        _controller.text = _formatDate(picked);
      });
      widget.onDatePicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: _pickDate,
    );
  }
}