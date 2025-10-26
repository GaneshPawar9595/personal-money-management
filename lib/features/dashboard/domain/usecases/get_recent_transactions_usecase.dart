import '../../../transaction/domain/entities/transaction_entity.dart';

/// Retrieves most recent transactions sorted by date
class GetRecentTransactionsUseCase {
  /// Returns the most recent N transactions
  ///
  /// Parameters:
  /// - [transactions]: All available transactions
  /// - [limit]: Maximum number of transactions to return
  ///
  /// Returns:
  /// - List sorted by date (newest first)
  List<TransactionEntity> call({
    required List<TransactionEntity> transactions,
    int limit = 3,
  }) {
    final sorted = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return sorted.take(limit).toList();
  }
}
