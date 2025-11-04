import 'package:flutter/material.dart';
import '../../../../../config/localization/app_localizations.dart'; // Adjust path as needed

class IncomeExpenseSwitch extends StatelessWidget {
  final bool isIncome;
  final ValueChanged<bool> onChanged;

  const IncomeExpenseSwitch({
    super.key,
    required this.isIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isIncome
              ? loc.translate('income')
              : loc.translate('expense'),
          style: const TextStyle(fontSize: 16),
        ),
        Switch(
          activeColor: Colors.deepPurple,
          value: isIncome,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
