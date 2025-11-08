import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../transaction/domain/entities/transaction_entity.dart';
import '../../provider/dashboard_provider.dart';
import '../../../../transaction/presentation/widgets/transaction_list.dart';
import '../../../../transaction/presentation/utils/delete_dialogs.dart';
import '../../../../transaction/presentation/utils/transaction_form_wrapper.dart';
import 'package:money_management/config/localization/app_localizations.dart';
import '../../../../transaction/presentation/provider/transaction_provider.dart';

class RecentTransactionsSection extends StatelessWidget {
  final String userId;
  final int limit;

  const RecentTransactionsSection({
    super.key,
    required this.userId,
    required this.limit,
  });

  Future<void> _confirmDelete(
      BuildContext context, TransactionEntity transaction) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDeleteConfirmationDialog(
      context,
      transaction.note,
    );
    if (confirmed != true) return;

    final provider = context.read<TransactionProvider>();
    try {
      await provider.deleteTransaction(userId, transaction.id);
      if (provider.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.translate('transaction_delete_failed')}: ${provider.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.translate('transaction_deleted_success'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.translate('transaction_delete_error')}: $e')),
        );
      }
    }
  }

  void _editTransaction(BuildContext context, TransactionEntity transaction) {
    showTransactionForm(context, userId, transaction);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final recentTransactions = dashboardProvider.getRecentTransactions(limit: limit);

        if (recentTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  loc.translate('no_transactions_yet'),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.translate('tap_plus_to_add_first_transaction'),
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return TransactionList(
          transactions: recentTransactions,
          onLongPress: (t) => _confirmDelete(context, t),
          onTap: (t) => _editTransaction(context, t),
          showHeaders: false,
          scrollPhysics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}
