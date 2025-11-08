import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_management/config/localization/app_localizations.dart';
import '../../../../transaction/presentation/provider/transaction_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../widgets/desktop/stats_cards/desktop_stats_card.dart';

class DesktopStatsCardsSection extends StatelessWidget {
  const DesktopStatsCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer2<DashboardProvider, TransactionProvider>(
      builder: (context, dashboardProvider, transactionProvider, child) {
        final transactions = dashboardProvider.transactions;
        final categorySummary = dashboardProvider.getCategorySummary();

        final totalIncome = transactions.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
        final totalExpenses = transactions.where((t) => !t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
        final balance = totalIncome - totalExpenses;
        final categoryCount = categorySummary.length;
        final transactionCount = transactions.length;

        final todayBalance = transactionProvider.getTodayAmountStatus();
        final todayLabel = todayBalance > 0
            ? loc.translate('today_positive').replaceAll('{amount}', todayBalance.toStringAsFixed(2))
            : todayBalance < 0
            ? loc.translate('today_negative').replaceAll('{amount}', todayBalance.abs().toStringAsFixed(2))
            : loc.translate('today_none');

        final cards = [
          DesktopStatsCard(
            title: loc.translate('total_balance'),
            value: '₹${balance.toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
            trend: balance >= 0 ? 'positive' : 'negative',
            subtitle: todayLabel,
          ),
          DesktopStatsCard(
            title: loc.translate('total_income'),
            value: '₹${totalIncome.toStringAsFixed(2)}',
            icon: Icons.trending_up,
            color: Colors.green,
            subtitle: '${transactions.where((t) => t.isIncome).length} ${loc.translate('transactions')}',
          ),
          DesktopStatsCard(
            title: loc.translate('total_expenses'),
            value: '₹${totalExpenses.toStringAsFixed(2)}',
            icon: Icons.trending_down,
            color: Colors.red,
            subtitle: '${transactions.where((t) => !t.isIncome).length} ${loc.translate('transactions')}',
          ),
          DesktopStatsCard(
            title: loc.translate('categories'),
            value: categoryCount.toString(),
            icon: Icons.category,
            color: Colors.orange,
            subtitle: '$transactionCount ${loc.translate('total_transactions')}',
          ),
        ];

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i < cards.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}
