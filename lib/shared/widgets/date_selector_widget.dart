import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../config/localization/app_localizations.dart'; // Adjust path as needed

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final formattedDate = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(selectedDate);

    return Row(
      children: [
        Expanded(
          child: Text(
            '${loc.translate('date')}: $formattedDate',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              locale: Localizations.localeOf(context),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Text(loc.translate('select_date')),
        ),
      ],
    );
  }
}