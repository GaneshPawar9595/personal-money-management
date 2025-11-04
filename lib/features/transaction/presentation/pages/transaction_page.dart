import 'package:flutter/cupertino.dart';
import 'package:money_management/features/transaction/presentation/pages/transaction_desktop_page.dart';
import 'package:money_management/features/transaction/presentation/pages/transaction_mobile_page.dart';
import 'package:money_management/features/transaction/presentation/pages/transaction_tablet_page.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/responsive_layout.dart';
import '../../../category/presentation/provider/category_provider.dart';

class TransactionPage extends StatefulWidget {
  final String userId;

  const TransactionPage({super.key, required this.userId});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      Future.microtask(() {
        context.read<CategoryProvider>().loadCategories(widget.userId);
      });
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: TransactionMobilePage(userId: widget.userId),
      tabletLayout: TransactionTabletPage(userId: widget.userId),
      desktopLayout: TransactionDesktopPage(userId: widget.userId),
    );
  }
}
