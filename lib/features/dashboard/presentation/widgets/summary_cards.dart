import 'package:flutter/material.dart';
import 'package:money_management/config/localization/app_localizations.dart';

class SummaryCards extends StatelessWidget {
  final double income;
  final double expense;
  final double net;

  const SummaryCards({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard(
            loc.translate('income'),
          income,
          Colors.green
        ),
        _buildCard(
           loc.translate('expense'),
          expense,
          Colors.red
        ),
        _buildCard(
          loc.translate('net'),
          net,
          Colors.blue
        ),
      ],
    );
  }

  Widget _buildCard(String title, double amount, Color color, ) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
