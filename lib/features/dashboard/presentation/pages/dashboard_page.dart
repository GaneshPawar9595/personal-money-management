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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      if (user == null) return; // user not ready yet

      // Fetch initial transactions without listening (safe during init)
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).loadTransactions(user.id);

      // Fetch initial transactions without listening (safe during init)
      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadCategories(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: DashboardMobile(),
      tabletLayout: DashboardMobile(),
      desktopLayout: DashboardDesktop(),
    );
  }
}
