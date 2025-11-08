import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../config/localization/app_localizations.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/presentation/provider/transaction_provider.dart';
import '../../../transaction/presentation/utils/delete_dialogs.dart';
import '../../../transaction/presentation/utils/transaction_form_wrapper.dart';
import '../provider/dashboard_provider.dart';
import '../sections/stats_cards/desktop_stats_cards_section.dart';
import '../sections/top_bar/desktop_top_bar.dart';
import '../sections/top_merchants/desktop_top_merchants_section.dart';
import '../sections/top_spend_category/desktop_category_breakdown_section.dart';
import '../sections/spending_trends/desktop_spending_chart_section.dart';
import '../sections/recent_transactions/desktop_recent_transactions_section.dart';

/// ✅ Desktop dashboard with multi-column grid layout.
class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DesktopHomeScreen> {

  @override
  void initState() {
    super.initState();

    // ✅ Sync DashboardProvider with TransactionProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = context.read<TransactionProvider>();
      final dashboardProvider = context.read<DashboardProvider>();

      // Initial sync
      dashboardProvider.setTransactions(transactionProvider.transactions);

      // ✅ Listen for changes in TransactionProvider and update dashboard
      transactionProvider.addListener(() {
        if (!mounted) return;
        dashboardProvider.setTransactions(transactionProvider.transactions);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final userId = user?.id;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const DesktopTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DesktopStatsCardsSection(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== LEFT COLUMN =====
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DesktopSpendingChartSection(
                              onAddTransaction: () => _addTransaction(userId!),
                            ),
                            const SizedBox(height: 24),
                            DesktopTopMerchantsSection(userId: userId!),
                            const SizedBox(height: 24),
                            const DesktopCategoryBreakdownSection(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // ===== RIGHT COLUMN =====
                      Expanded(
                        flex: 4,
                        child: DesktopRecentTransactionsSection(
                          onEdit: (t) => _editTransaction(userId, t),
                          onDelete: (t) => _confirmDelete(userId, t),
                          onViewAll: () => context.go('/transaction'),
                          title: loc.translate('recent_transactions_title'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Confirm delete dialog
  Future<void> _confirmDelete(String userId, TransactionEntity transaction) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDeleteConfirmationDialog(
      context,
      transaction.note,
    );
    if (confirmed != true) return;

    final provider = context.read<TransactionProvider>();
    try {
      await provider.deleteTransaction(userId, transaction.id);
      if (provider.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.translate('transaction_delete_failed')}: ${provider.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.translate('transaction_deleted_success'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.translate('transaction_delete_error')}: $e')),
        );
      }
    }
  }

  /// ✅ Edit transaction
  void _editTransaction(String userId, TransactionEntity transaction) {
    showTransactionForm(context, userId, transaction);
  }

  /// ✅ Add new transaction
  void _addTransaction(String userId) {
    showTransactionForm(context, userId, null);
  }
}
