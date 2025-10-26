import '../../../transaction/domain/entities/transaction_entity.dart';
import '../entities/category_summary_entity.dart';

/// Calculates aggregated spending by category
/// Returns sorted list (highest spending first)
/// Only includes expense transactions
class CalculateCategorySummaryUseCase {
  /// Groups transactions by category and calculates totals
  ///
  /// Parameters:
  /// - [transactions]: List of all transactions
  /// - [startDate]: Optional filter - include transactions after this date
  /// - [endDate]: Optional filter - include transactions before this date
  /// - [calculatePercentage]: Whether to calculate percentage of total spend
  List<CategorySummaryEntity> call({
    required List<TransactionEntity> transactions,
    DateTime? startDate,
    DateTime? endDate,
    bool calculatePercentage = false,
  }) {
    final Map<String, CategorySummaryEntity> summaryMap = {};
    double totalSpent = 0.0;

    for (final tx in transactions) {
      // Skip income transactions
      if (tx.isIncome) continue;

      // Apply date filters if provided
      if (startDate != null && tx.date.isBefore(startDate)) continue;
      if (endDate != null && tx.date.isAfter(endDate)) continue;

      final category = tx.categoryEntity;
      final amount = tx.amount;

      totalSpent += amount;

      // Aggregate by category ID
      if (summaryMap.containsKey(category.id)) {
        summaryMap[category.id] = summaryMap[category.id]!.copyWith(
          amount: summaryMap[category.id]!.amount + amount,
          transactionCount: summaryMap[category.id]!.transactionCount + 1,
        );
      } else {
        summaryMap[category.id] = CategorySummaryEntity(
          category: category,
          amount: amount,
          transactionCount: 1,
        );
      }
    }

    // Calculate percentages if requested
    if (calculatePercentage && totalSpent > 0) {
      summaryMap.updateAll((_, value) {
        final percentage = (value.amount / totalSpent) * 100;
        return value.copyWith(
          percentage: double.parse(percentage.toStringAsFixed(2)),
        );
      });
    }

    // Sort by amount (highest first)
    final sortedList = summaryMap.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return sortedList;
  }
}
