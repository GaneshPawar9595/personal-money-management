import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/features/transaction/presentation/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../../../../config/localization/app_localizations.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({super.key});

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWeb = MediaQuery.of(context).size.width > 600;

    // Compute today's amount status once
    final todayAmountStatus = transactionProvider.getTodayAmountStatus();
    final todayStatusColor = todayAmountStatus < 0 ? Colors.red : Colors.green;

    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () {
            context.push("/profile");
          },
          child: Hero(
            tag: "profileImage",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: auth.user!.profileImageBytes != null &&auth.user!.profileImageBytes!.isNotEmpty
                  ? Image.memory(
                auth.user!.profileImageBytes!,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
              )
                  : const Icon(Icons.person, color: Colors.white, size: 40),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.black, Colors.grey.shade900]
                  : [Colors.blue.shade600, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      loc?.translate('heading_total_balance') ?? 'Total Balance',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: isWeb ? 24 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: transactionProvider.getTotalAmount(),
                      ),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Text(
                          "₹ ${value.toStringAsFixed(2)}",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "₹ $todayAmountStatus",
                      style: GoogleFonts.inter(
                        color: todayStatusColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
