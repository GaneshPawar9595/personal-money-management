import 'package:flutter/material.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Income', style: TextStyle(fontSize: 16)),
        Switch(
          activeColor: Colors.deepPurple,
          value: isIncome,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
