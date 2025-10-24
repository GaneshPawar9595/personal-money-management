import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search by note or category",
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
            itemBuilder: (context) => const [
              PopupMenuItem(value: "All", child: Text("All")),
              PopupMenuItem(value: "Income", child: Text("Income")),
              PopupMenuItem(value: "Expense", child: Text("Expense")),
            ],
          ),
        ],
      ),
    );
  }
}
