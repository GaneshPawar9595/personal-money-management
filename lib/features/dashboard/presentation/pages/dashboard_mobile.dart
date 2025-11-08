import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../transaction/presentation/provider/transaction_provider.dart';
import '../../../transaction/presentation/utils/transaction_form_wrapper.dart';
import '../provider/dashboard_provider.dart';
import '../sections/recent_transactions/recent_transactions_section.dart';
import '../sections/top_bar/custom_sliver_appbar.dart';
import '../widgets/section_header.dart';
import 'package:money_management/config/localization/app_localizations.dart';

import '../sections/spending_trends/spending_trends_section.dart';
import '../sections/top_merchants/top_merchants_section.dart';
import '../sections/top_spend_category/top_spend_category_section.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  static const int _recentTransactionCount = 3;
  late final TransactionProvider _transactionProvider;
  late final DashboardProvider _dashboardProvider;

  void _syncDashboard() {
    if (!mounted) return;
    _dashboardProvider.setTransactions(_transactionProvider.transactions);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transactionProvider = context.read<TransactionProvider>();
      _dashboardProvider = context.read<DashboardProvider>();
      _syncDashboard();
      _transactionProvider.addListener(_syncDashboard);
    });
  }

  @override
  void dispose() {
    if (mounted) {
      try {
        _transactionProvider.removeListener(_syncDashboard);
      } catch (_) {}
    }
    super.dispose();
  }

  void _navigateToTransactions() {
    context.push('/transaction');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (auth.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/signin');
      });
      return Scaffold(body: Center(child: Text(loc.translate('please_sign_in'))));
    }

    final userId = user.id;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(),
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
                        SectionHeader(
                          title: loc.translate('recent_transactions'),
                          icon: Icons.history,
                          onViewAll: _navigateToTransactions,
                        ),
                        RecentTransactionsSection(
                          userId: userId,
                          limit: _recentTransactionCount,
                        ),
                        const SizedBox(height: 20),

                        SectionHeader(
                          title: loc.translate('top_merchants'),
                          icon: Icons.store,
                        ),
                        TopMerchantsSection(userId: userId, crossAxisItemCount: 2),
                        const SizedBox(height: 20),

                        SectionHeader(
                          title: loc.translate('top_spends_category'),
                          icon: Icons.pie_chart,
                        ),
                        const TopSpendCategorySection(),
                        const SizedBox(height: 20),

                        SectionHeader(
                          title: loc.translate('top_spends'),
                          icon: Icons.show_chart,
                        ),
                        const SpendingTrendsSection(),
                        const SizedBox(height: 75),
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
