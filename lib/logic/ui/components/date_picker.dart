import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;
  final List<DateTime> disabledDates; 

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.label,
    this.disabledDates = const [], 
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (day) {
      
        if (disabledDates.isEmpty) return true;
        return !disabledDates.any((d) =>
          d.year == day.year &&
          d.month == day.month &&
          d.day == day.day,
        );
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navy,
              onPrimary: Colors.white,
              onSurface: AppColors.navygrey,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(15),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today, color: AppColors.navy),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('dd MMMM yyyy').format(selectedDate!)
              : "Pilih Tanggal",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}