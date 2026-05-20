import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorWidget extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelectorWidget({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        onDateSelected(dateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: () => _selectDateTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
          border: const OutlineInputBorder(),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        child: Text(
          selectedDate != null
              ? DateFormat('MMM dd, yyyy HH:mm').format(selectedDate!)
              : 'Select date and time',
          style: TextStyle(
            fontSize: 16.sp,
            color: selectedDate != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
