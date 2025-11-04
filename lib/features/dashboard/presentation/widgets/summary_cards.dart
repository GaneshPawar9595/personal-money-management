import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  final double income;
  final double expense;
  final double net;

  const SummaryCards({super.key, required this.income, required this.expense, required this.net});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard('Income', income, Colors.green),
        _buildCard('Expense', expense, Colors.red),
        _buildCard('Net', net, Colors.blue),
      ],
    );
  }

  Widget _buildCard(String title, double amount, Color color) {
    return Card(
      color: color.withValues(alpha:0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
