import '../entities/transaction_entity.dart';

class FilterTransactionsUseCase  {
  /// Filters transactions by optional category, income/expense flag, and date.
  static List<TransactionEntity> filterTransactions(
      List<TransactionEntity> transactions, {
        String? categoryId,
        bool? incomeFilter,
        DateTime? dateFilter,
      }) {
    return transactions.where((transaction) {
      final matchesCategory = categoryId == null || transaction.categoryEntity.id == categoryId;
      final matchesIncome = incomeFilter == null || transaction.isIncome == incomeFilter;
      final matchesDate = dateFilter == null
          ? true
          : transaction.date.year == dateFilter.year &&
          transaction.date.month == dateFilter.month &&
          transaction.date.day == dateFilter.day;

      return matchesCategory && matchesIncome && matchesDate;
    }).toList();
  }
}
