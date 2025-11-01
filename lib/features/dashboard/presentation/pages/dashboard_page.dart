import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../transaction/presentation/provider/transaction_provider.dart';
import 'dashboard_mobile.dart';
import 'dashboard_desktop.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _loadedProviders = false; // Protection: To prevent duplicate loads

  @override
  void initState() {
    super.initState();
    // Defer any data loading until after build and Provider setup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // Centralized data loading for transactions and categories
  void _loadInitialData() {
    if (_loadedProviders) return; // Avoid running twice
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    // Only load if user is available (ensured by splash & route guards)
    if (authProvider.isLoggedIn && user != null) {
      Provider.of<TransactionProvider>(context, listen: false).loadTransactions(user.id);
      Provider.of<CategoryProvider>(context, listen: false).loadCategories(user.id);
      _loadedProviders = true; // Mark providers as loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive: Use appropriate layout for screen size
    return ResponsiveLayout(
      mobileLayout: DashboardMobile(),
      tabletLayout: DashboardMobile(),
      desktopLayout: DashboardDesktop(),
    );
  }
}
