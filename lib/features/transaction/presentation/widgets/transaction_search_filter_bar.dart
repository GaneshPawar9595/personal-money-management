import 'package:flutter/material.dart';
import '../../../../../config/localization/app_localizations.dart'; // Adjust path if needed

class TransactionSearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final bool showOnlyIncome;
  final bool showOnlyExpense;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;

  const TransactionSearchFilterBar({
    super.key,
    required this.controller,
    required this.showOnlyIncome,
    required this.showOnlyExpense,
    required this.onSearchChanged,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: loc.translate('search_note_or_category'),
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              controller: controller,
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: onFilterSelected,
            itemBuilder: (context) => [
              PopupMenuItem(value: "All", child: Text(loc.translate('all'))),
              PopupMenuItem(value: "Income", child: Text(loc.translate('income'))),
              PopupMenuItem(value: "Expense", child: Text(loc.translate('expense'))),
            ],
          ),
        ],
      ),
    );
  }
}
