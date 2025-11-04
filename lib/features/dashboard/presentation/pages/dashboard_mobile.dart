import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/presentation/provider/transaction_provider.dart';
import '../../../transaction/presentation/utils/delete_dialogs.dart';
import '../../../transaction/presentation/utils/transaction_form_wrapper.dart';
import '../../../transaction/presentation/widgets/transaction_list.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/custom_sliver_appbar.dart';
import '../widgets/section_header.dart';
import '../widgets/top_merchants_section.dart';
import '../widgets/top_spend_category_section.dart';
import '../widgets/spending_trends_section.dart';

/// This screen is the main dashboard on phones:
/// it greets the user, shows quick stats and charts, and lists the latest transactions. [web:101][web:104]
class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key}); // No extra setup needed to create this screen.

  @override
  State<DashboardMobile> createState() => _DashboardMobileState(); // Creates the part that handles updates.
}

class _DashboardMobileState extends State<DashboardMobile> {
  static const int _recentTransactionCount = 3; // Show just a few recent items on the home screen.

  late final TransactionProvider _transactionProvider; // Manages the user’s transactions list. [web:101][web:104]
  late final DashboardProvider _dashboardProvider; // Prepares the numbers and lists shown on this page.

  /// Keeps dashboard sections in sync whenever the transactions change. [web:101][web:104]
  void _syncDashboard() {
    if (!mounted) return; // Only update if this screen is still visible. [web:101][web:104]
    _dashboardProvider.setTransactions(_transactionProvider.transactions); // Share the latest transactions with the dashboard. [web:101][web:104]
  }

  @override
  void initState() {
    super.initState();

    // Wait for the first frame so context.read() is safe and widgets are ready. [web:101][web:104]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transactionProvider = context.read<TransactionProvider>(); // Get the transactions manager. [web:101][web:104]
      _dashboardProvider = context.read<DashboardProvider>(); // Get the dashboard manager. [web:101][web:104]
      _syncDashboard(); // Initial sync so the page has data right away. [web:101][web:104]
      _transactionProvider.addListener(_syncDashboard); // Keep updating when transactions change. [web:101][web:104]
    });
  }

  @override
  void dispose() {
    // Stop listening when leaving this screen to avoid memory leaks. [web:101][web:104]
    if (mounted) {
      // Guard in case initState’s callback never ran. [web:101][web:104]
      try {
        _transactionProvider.removeListener(_syncDashboard); // Clean up listener if it was added. [web:101][web:104]
      } catch (_) {
        // Safe to ignore if provider wasn’t set yet. [web:101][web:104]
      }
    }
    super.dispose(); // Finish cleanup. [web:101][web:104]
  }

  /// Shows a confirmation box; if approved, deletes the chosen transaction and reports any problem. [web:101][web:104]
  Future<void> _confirmDelete(
    String userId,
    TransactionEntity transaction,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      transaction.note,
    );// Ask the user if they’re sure.

    if (confirmed != true) return; // If they cancel, do nothing.

    final provider = context.read<TransactionProvider>(); // Use the transactions manager to delete.

    try {
      await provider.deleteTransaction(userId, transaction.id); // Try to delete it.

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

  /// Opens transaction form for editing
  void _editTransaction(String userId, TransactionEntity transaction) {
    showTransactionForm(context, userId, transaction);
  }

  /// Navigates to transaction page
  void _navigateToTransactions() {
    context.push('/transaction');
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
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(),

          // Main content
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== RECENT TRANSACTIONS =====
                        SectionHeader(
                          title: "RECENT TRANSACTIONS",
                          icon: Icons.history,
                          onViewAll: _navigateToTransactions,
                        ),
                        RecentTransactionsSection(
                          userId: userId,
                          limit: _recentTransactionCount,
                          onDelete: _confirmDelete,
                          onEdit: _editTransaction,
                        ),
                        const SizedBox(height: 20),

                        // ===== TOP MERCHANTS =====
                        SectionHeader(
                          title: "TOP MERCHANTS",
                          icon: Icons.store,
                          //onViewAll: _navigateToTransactions,
                        ),
                        TopMerchantsSection(userId: userId, crossAxisItemCount: 2,),
                        const SizedBox(height: 20),

                        // ===== TOP SPEND CATEGORY =====
                        const SectionHeader(
                          title: "TOP SPENDS CATEGORY",
                          icon: Icons.pie_chart,
                        ),
                        const TopSpendCategorySection(),
                        const SizedBox(height: 20),

                        // ===== SPENDING TRENDS =====
                        const SectionHeader(
                          title: "TOP SPENDS",
                          icon: Icons.show_chart,
                        ),
                        const SpendingTrendsSection(),
                        SizedBox(height: 75),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTransactionForm(context, userId, null),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}

/// ===============================
/// 📦 RECENT TRANSACTIONS SECTION
/// ===============================
class RecentTransactionsSection extends StatelessWidget {
  final String userId;
  final int limit;
  final void Function(String, TransactionEntity) onDelete;
  final void Function(String, TransactionEntity) onEdit;

  const RecentTransactionsSection({
    super.key,
    required this.userId,
    required this.limit,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final recentTransactions = dashboardProvider.getRecentTransactions(
          limit: limit,
        );

        if (recentTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first transaction',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return TransactionList(
          transactions: recentTransactions,
          onLongPress: (t) => onDelete(userId, t),
          onTap: (t) => onEdit(userId, t),
          showHeaders: false,
          scrollPhysics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}
