import 'package:intl/intl.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../entities/spending_trend_entity.dart';

enum TimeRange { weekly, monthly, yearly }

/// Calculates spending trends over time periods
/// Groups expenses by day, month, or year based on selected range
class CalculateSpendingTrendsUseCase {
  /// Aggregates spending data for the selected time range
  ///
  /// Parameters:
  /// - [transactions]: All transactions to analyze
  /// - [timeRange]: Weekly, Monthly, or Yearly grouping
  ///
  /// Returns:
  /// - List of spending trends sorted by time period
  /// - Amounts are in thousands (divided by 1000)
  List<SpendingTrendEntity> call({
    required List<TransactionEntity> transactions,
    required TimeRange timeRange,
  }) {
    final Map<int, double> spendingMap = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final transaction in transactions) {
      // Only include expenses
      if (transaction.isIncome) continue;

      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      int? key;
      bool includeTransaction = false;

      switch (timeRange) {
        case TimeRange.weekly:
        // Last 7 days (0-6)
          final startDate = today.subtract(const Duration(days: 6));
          if (date.isBefore(startDate) || date.isAfter(today)) break;
          key = date.difference(startDate).inDays;
          includeTransaction = true;
          break;

        case TimeRange.monthly:
        // Last 12 months
          final startMonth = DateTime(now.year - 1, now.month + 1);
          final endMonth = DateTime(now.year, now.month + 1);
          if (date.isBefore(startMonth) || date.isAfter(endMonth)) break;
          key = date.year * 100 + date.month; // e.g., 202510
          includeTransaction = true;
          break;

        case TimeRange.yearly:
        // Last 7 years
          final startYear = now.year - 6;
          if (date.year < startYear || date.year > now.year) break;
          key = date.year;
          includeTransaction = true;
          break;
      }

      if (includeTransaction && key != null) {
        final amountInThousands = transaction.amount / 1000;
        spendingMap[key] = (spendingMap[key] ?? 0) + amountInThousands;
      }
    }

    // Convert to entities with labels
    final trends = spendingMap.entries.map((entry) {
      final label = _getLabel(entry.key, timeRange, now, today);
      final amount = double.parse(entry.value.toStringAsFixed(2));

      return SpendingTrendEntity(
        key: entry.key,
        amount: amount,
        label: label,
      );
    }).toList();

    // Sort by key (chronological order)
    trends.sort((a, b) => a.key.compareTo(b.key));

    return trends;
  }

  /// Generates display labels based on time range
  String _getLabel(int key, TimeRange timeRange, DateTime now, DateTime today) {
    switch (timeRange) {
      case TimeRange.weekly:
        final date = today.subtract(Duration(days: 6 - key));
        return DateFormat('E').format(date); // "Mon", "Tue", etc.

      case TimeRange.monthly:
        final year = key ~/ 100;
        final month = key % 100;
        if (month >= 1 && month <= 12) {
          return DateFormat('MMM').format(DateTime(year, month)).toUpperCase();
        }
        return '';

      case TimeRange.yearly:
        return key.toString(); // "2025"
    }
  }

  /// Calculates percentage change between last two periods
  /// Returns positive value for increase, negative for decrease
  double calculatePercentageChange(List<SpendingTrendEntity> trends) {
    if (trends.length < 2) return 0.0;

    final current = trends.last.amount;
    final previous = trends[trends.length - 2].amount;

    if (previous == 0) return 0.0;

    return ((current - previous) / previous) * 100;
  }

  /// Generates all possible keys for a time range (for chart display)
  /// Ensures all bars are shown even if spending is 0
  List<int> getAllKeysForRange(TimeRange timeRange) {
    final now = DateTime.now();

    switch (timeRange) {
      case TimeRange.weekly:
        return List.generate(7, (i) => i); // 0-6

      case TimeRange.monthly:
        return List.generate(12, (i) {
          final date = DateTime(now.year, now.month - 11 + i);
          return date.year * 100 + date.month;
        });

      case TimeRange.yearly:
        final currentYear = now.year;
        return List.generate(7, (i) => currentYear - 6 + i);
    }
  }
}
