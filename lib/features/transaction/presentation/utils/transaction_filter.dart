import '../../domain/entities/transaction_entity.dart';

List<TransactionEntity> filterTransactions(
    List<TransactionEntity> transactions,
    String searchQuery,
    bool showOnlyIncome,
    bool showOnlyExpense,
    ) {
  var filtered = transactions;

  if (showOnlyIncome) {
    filtered = filtered.where((t) => t.isIncome).toList();
  } else if (showOnlyExpense) {
    filtered = filtered.where((t) => !t.isIncome).toList();
  }

  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((t) =>
    t.note.toLowerCase().contains(searchQuery.toLowerCase()) ||
        t.categoryEntity.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  return filtered;
}
