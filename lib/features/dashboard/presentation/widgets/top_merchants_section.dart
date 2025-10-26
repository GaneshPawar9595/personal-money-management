import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/dashboard_provider.dart';
import '../../../transaction/presentation/widgets/merchant_card.dart';
import 'time_range_selector.dart';

/// Top merchants widget with time range filtering
/// Displays spending aggregated by category (merchants)
class TopMerchantsSection extends StatelessWidget {
  final String userId;
  final int crossAxisItemCount;

  const TopMerchantsSection({
    super.key,
    required this.userId,
    required this.crossAxisItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final merchants = dashboardProvider.getMerchantSummary();

        if (merchants.isEmpty) {
          return Center(
            child: Text(
              "No spending data available",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time range selector
            TimeRangeSelector(
              selectedRange: dashboardProvider.selectedMerchantsRange,
              onRangeChanged: dashboardProvider.setMerchantsRange,
            ),
            const SizedBox(height: 16),

            // ✅ Merchants grid with wrap or natural sizing
            GridView.builder(
              shrinkWrap: true, // ✅ Let grid size itself
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisItemCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: merchants.length,
              itemBuilder: (context, index) {
                final summary = merchants[index];
                return MerchantCard(
                  category: summary.category,
                  amount: summary.amount,
                  count: summary.transactionCount,
                  userId: userId,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
