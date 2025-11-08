import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../transaction/domain/entities/transaction_entity.dart';
import '../../provider/dashboard_provider.dart';
import 'package:money_management/config/localization/app_localizations.dart';

import 'desktop_transaction_item.dart';

class DesktopRecentTransactionsSection extends StatelessWidget {
  final Function(TransactionEntity) onEdit;
  final Function(TransactionEntity) onDelete;
  final VoidCallback onViewAll;
  final String? title;
  final String? emptyText;
  final bool showViewAll;

  const DesktopRecentTransactionsSection({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onViewAll,
    this.title,
    this.emptyText,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title ?? loc.translate('recent_transactions_title'),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                /*if (showViewAll)
                  TextButton.icon(
                    onPressed: onViewAll,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(loc.translate('view_all')),
                  ),*/
              ],
            ),
          ),
          const Divider(height: 1),
          Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              final recentTransactions = dashboardProvider.getRecentTransactions(limit: 10);

              if (recentTransactions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          emptyText ?? loc.translate('no_transactions_yet'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTransactions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return DesktopTransactionItem(
                    transaction: transaction,
                    onEdit: () => onEdit(transaction),
                    onDelete: () => onDelete(transaction),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
