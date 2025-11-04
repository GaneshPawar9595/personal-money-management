import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/provider/auth_provider.dart';
import '../../../../transaction/domain/entities/transaction_entity.dart';
import '../../../../transaction/presentation/provider/transaction_provider.dart';
import '../../../../transaction/presentation/utils/delete_dialogs.dart';
import '../../../../transaction/presentation/utils/transaction_form_wrapper.dart';
import '../../provider/dashboard_provider.dart';
import 'desktop_stats_card.dart';
import 'desktop_top_merchants_section.dart';
import 'desktop_category_breakdown_section.dart';
import 'desktop_spending_chart_section.dart';
import 'desktop_recent_transactions_section.dart';

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
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (auth.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/signin');
      });
      return const Scaffold(body: Center(child: Text('Please sign in')));
    }

    final userId = user.id;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCards(),
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
                              onAddTransaction: () => _addTransaction(userId),
                            ),
                            const SizedBox(height: 24),
                            DesktopTopMerchantsSection(userId: userId),
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

  /// ✅ Top App Bar
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Dashboard',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    backgroundImage:
                        (user?.profileImage != null &&
                                user!.profileImage!.isNotEmpty)
                            ? MemoryImage(user.profileImageBytes!)
                            : null,
                    child:
                        (user?.profileImage == null ||
                                user!.profileImage!.isEmpty)
                            ? Text(
                              (user?.name != null && user!.name.isNotEmpty)
                                  ? user.name[0].toUpperCase()
                                  : 'U',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.email ?? 'User',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// ✅ Stats cards showing key metrics
  Widget _buildStatsCards() {
    return Consumer2<DashboardProvider, TransactionProvider>(
      builder: (context, dashboardProvider, transactionProvider, child) {
        final transactions = dashboardProvider.transactions;
        final categorySummary = dashboardProvider.getCategorySummary();

        final totalIncome = transactions
            .where((t) => t.isIncome)
            .fold(0.0, (sum, t) => sum + t.amount);
        final totalExpenses = transactions
            .where((t) => !t.isIncome)
            .fold(0.0, (sum, t) => sum + t.amount);
        final balance = totalIncome - totalExpenses;
        final categoryCount = categorySummary.length;
        final transactionCount = transactions.length;

        final todayBalance = transactionProvider.getTodayAmountStatus();
        final todayLabel =
            todayBalance > 0
                ? 'Today: +₹${todayBalance.toStringAsFixed(2)}'
                : todayBalance < 0
                ? 'Today: -₹${todayBalance.abs().toStringAsFixed(2)}'
                : 'No transactions today';

        final cards = [
          DesktopStatsCard(
            title: 'Total Balance',
            value: '₹${balance.toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
            trend: balance >= 0 ? 'positive' : 'negative',
            subtitle: todayLabel,
          ),
          DesktopStatsCard(
            title: 'Total Income',
            value: '₹${totalIncome.toStringAsFixed(2)}',
            icon: Icons.trending_up,
            color: Colors.green,
            subtitle:
                '${transactions.where((t) => t.isIncome).length} transactions',
          ),
          DesktopStatsCard(
            title: 'Total Expenses',
            value: '₹${totalExpenses.toStringAsFixed(2)}',
            icon: Icons.trending_down,
            color: Colors.red,
            subtitle:
                '${transactions.where((t) => !t.isIncome).length} transactions',
          ),
          DesktopStatsCard(
            title: 'Categories',
            value: categoryCount.toString(),
            icon: Icons.category,
            color: Colors.orange,
            subtitle: '$transactionCount total transactions',
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

  /// ✅ Confirm delete dialog
  Future<void> _confirmDelete(
    String userId,
    TransactionEntity transaction,
  ) async {
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
          SnackBar(
            content: Text('Failed to delete transaction: ${provider.error}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting transaction: $e')),
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
