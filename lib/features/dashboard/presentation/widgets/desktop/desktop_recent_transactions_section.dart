import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../transaction/domain/entities/transaction_entity.dart';
import '../../provider/dashboard_provider.dart';
import 'desktop_transaction_item.dart';

/// Desktop recent transactions with compact list
class DesktopRecentTransactionsSection extends StatelessWidget {
  final Function(TransactionEntity) onEdit;
  final Function(TransactionEntity) onDelete;
  final VoidCallback onViewAll;

  const DesktopRecentTransactionsSection({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Recent Transactions',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
               /* TextButton.icon(
                  onPressed: onViewAll,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('View All'),
                ),*/
              ],
            ),
          ),

          const Divider(height: 1),

          // Transactions List
          Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              final recentTransactions =
              dashboardProvider.getRecentTransactions(limit: 10);

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
                          'No transactions yet',
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
