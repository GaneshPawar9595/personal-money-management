import '../entities/transaction_entity.dart';

/// Use case that calculates the net amount of today's transactions,
/// considering income and expenses.
class GetTodayAmountStatusUseCase {
  /// Calculates the net amount of today's transactions.
  ///
  /// Returns the sum of income amounts minus expense amounts
  /// for all transactions occurring on the current date.
  static double getTodayAmountStatus(List<TransactionEntity> transactions) {
    double total = 0;
    final today = DateTime.now();

    final todayTransactions = transactions.where((transaction) {
      final transactionDate = transaction.date;
      return transactionDate.year == today.year &&
          transactionDate.month == today.month &&
          transactionDate.day == today.day;
    });

    for (var transaction in todayTransactions) {
      final amount = transaction.amount;
      if (transaction.isIncome) {
        total += amount;
      } else {
        total -= amount;
      }
    }

    return total;
  }
}
