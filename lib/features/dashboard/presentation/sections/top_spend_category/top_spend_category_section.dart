import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/features/dashboard/presentation/widgets/time_range_selector.dart';
import 'package:provider/provider.dart';
import '../../../../../config/localization/app_localizations.dart';
import '../../provider/dashboard_provider.dart';
import '../../../domain/entities/category_summary_entity.dart';

/// Top spending category section with pie chart and breakdown
class TopSpendCategorySection extends StatelessWidget {
  const TopSpendCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final categorySummary = dashboardProvider.getCategorySummary();
        final totalSpent = dashboardProvider.getTotalSpending();
        final topCategory = dashboardProvider.getTopCategory();

        if (categorySummary.isEmpty || topCategory == null) {
          return Center(
            child: Text(
              loc.translate('no_spend_data_available'),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Time range selector
              TimeRangeSelector(
                selectedRange: dashboardProvider.selectedCategoryRange,
                onRangeChanged: dashboardProvider.setCategoryRange,
                labels: [
                   loc.translate('this_week'),
                   loc.translate('this_month'),
                   loc.translate('this_year')
                ],
              ),
              const SizedBox(height: 16),

              // Top category headline
              Text(
                "${topCategory.percentage.toStringAsFixed(1)}% on ${topCategory.category.name}",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Category message
              Text(
                topCategory.category.message,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Pie chart
              Center(child: _buildPieChart(categorySummary, totalSpent)),
              const SizedBox(height: 30),

              // Category breakdown list
              ..._buildExpenseList(categorySummary, loc),
            ],
          ),
        );
      },
    );
  }

  /// Builds pie chart showing category distribution
  Widget _buildPieChart(
      List<CategorySummaryEntity> categories,
      double totalSpent,
      ) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              startDegreeOffset: -90,
              sections: categories.map((summary) {
                return PieChartSectionData(
                  value: summary.percentage,
                  color: summary.category.color,
                  radius: 25,
                  title: '',
                );
              }).toList(),
            ),
          ),
          // Total amount in center
          Text(
            "₹${totalSpent.toStringAsFixed(2)}",
            style: GoogleFonts.robotoMono(fontSize: 18),
          ),
        ],
      ),
    );
  }

  /// Builds list of category expense items
  List<Widget> _buildExpenseList(List<CategorySummaryEntity> categories, AppLocalizations loc) {
    return categories.map((expense) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: expense.category.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Category name and transaction count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    loc.translate('category_transaction_count', args: [expense.transactionCount.toString()]),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${expense.amount.toStringAsFixed(2)}",
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${expense.percentage.toStringAsFixed(2)}%",
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
