import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../config/localization/app_localizations.dart';
import '../../provider/dashboard_provider.dart';
import '../../widgets/time_range_selector.dart';
import '../../../domain/usecases/calculate_spending_trends_usecase.dart';

/// Spending trends chart with time range selector
class SpendingTrendsSection extends StatefulWidget {
  const SpendingTrendsSection({super.key});

  @override
  State<SpendingTrendsSection> createState() => _SpendingTrendsSectionState();
}

class _SpendingTrendsSectionState extends State<SpendingTrendsSection> {
  int? selectedBarIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls chart to show selected bar
  void _scrollToSelectedBar(List<int> keys) {
    if (selectedBarIndex == null || keys.isEmpty) return;

    final index = keys.indexOf(selectedBarIndex!);
    if (index == -1) return;

    const double barWidth = 70;
    const double visibleBars = 4;
    final double offset = (index - (visibleBars - 1)) * barWidth;

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final trends = dashboardProvider.getSpendingTrends();
        final percentageChange = dashboardProvider.getSpendingPercentageChange();
        final allKeys = dashboardProvider.getAllTrendsKeys();
        final selectedRange = dashboardProvider.selectedTrendsRange;
        final isIncrease = percentageChange > 0;

        if (trends.isEmpty) {
          return Center(
            child: Text(
              loc.translate('no_spend_trends_available'),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        // Initialize selected bar to latest period
        final trendKeys = trends.map((t) => t.key).toList();
        selectedBarIndex ??= trendKeys.isNotEmpty ? trendKeys.last : null;

        // Auto-scroll to selected bar after render
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedBar(allKeys);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Percentage change indicator
            Row(
              children: [
                Text(
                  "${percentageChange.abs().toStringAsFixed(2)}%",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isIncrease ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: isIncrease ? Colors.red : Colors.green,
                ),
              ],
            ),

            // Feedback message
            Text(
              isIncrease
                  ? loc.translate('spending_increased_msg')
                  : loc.translate('spending_decreased_msg'),
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),

            // Time range selector
            TimeRangeSelector(
              selectedRange: dashboardProvider.selectedTrendsRange,
              onRangeChanged: (range) {
                dashboardProvider.setTrendsRange(range);
                setState(() {
                  selectedBarIndex = null; // Reset selection on range change
                });
              },
              labels: [
                loc.translate('weekly'),
                loc.translate('monthly'),
                loc.translate('yearly'),
              ],
            ),
            const SizedBox(height: 20),

            // Bar chart
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: SizedBox(
                  width: allKeys.length * 70.0,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _buildBarGroups(trends, allKeys),
                      borderData: FlBorderData(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // ========== FIXED: Direct label generation from key ==========
                              return _getBottomLabel(
                                value.toInt(),
                                selectedRange,
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions &&
                              response?.spot != null) {
                            setState(() {
                              final touchedIndex =
                                  response!.spot!.touchedBarGroupIndex;
                              selectedBarIndex = allKeys[touchedIndex];
                            });
                          }
                        },
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "₹${rod.toY.toStringAsFixed(2)}K",
                              GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            );
                          },
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Generates bottom label widget based on key and time range
  Widget _getBottomLabel(int val, TimeRange selectedRange) {

    final style = GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    if (selectedRange == TimeRange.weekly) {
      // Weekly: keys are 0-6
      final today = DateTime.now();
      final weekDays = List.generate(7, (i) {
        final date = today.subtract(Duration(days: 6 - i));
        return DateFormat('E').format(date); // 'Mon', 'Tue' ...
      });

      if (val >= 0 && val < weekDays.length) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(weekDays[val], style: style),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else if (selectedRange == TimeRange.monthly) {
      // Monthly: keys are YYYYMM (e.g., 202510)
      int year = val ~/ 100;
      int month = val % 100;

      if (month >= 1 && month <= 12) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            DateFormat('MMM').format(DateTime(year, month)).toUpperCase(),
            style: style,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      // Yearly: keys are YYYY (e.g., 2025)
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(val.toString(), style: style),
      );
    }
  }

  /// Builds bar chart groups with data and styling
  List<BarChartGroupData> _buildBarGroups(
      List trends,
      List<int> allKeys,
      ) {
      // Create map for O(1) lookup
      final trendMap = {for (var t in trends) t.key: t.amount};

      return List.generate(allKeys.length, (index) {
        final key = allKeys[index];
        final amount = trendMap[key] ?? 0.0;
        final isSelected = selectedBarIndex == key;

        return BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              toY: amount as double,
              width: 20,
              color: isSelected ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.zero,
            ),
          ],
          showingTooltipIndicators: isSelected ? [0] : [],
        );
      });
    }

}
