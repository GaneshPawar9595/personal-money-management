import 'package:flutter_test/flutter_test.dart';
import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management/features/category/domain/entities/category_entity.dart';
import 'package:money_management/features/transaction/domain/usecases/filter_transactions_usecase.dart';

void main() {
  final category1 = CategoryEntity(
    id: 'cat1',
    name: 'Food',
    userId: '',
    colorHex: '0xFFF44336', // Use a valid color hex int
    message: '',
    iconCodePoint: 0xe56c, // Example icon code point
  );

  final category2 = CategoryEntity(
    id: 'cat2',
    name: 'Salary',
    userId: '',
    colorHex: '0xFF4CAF50',
    message: '',
    iconCodePoint: 0xe227,
  );

  final transactions = [
    TransactionEntity(
      id: 't1',
      note: 'Lunch',
      amount: 150,
      date: DateTime(2025, 11, 2),
      categoryEntity: category1,
      isIncome: false,
    ),
    TransactionEntity(
      id: 't2',
      note: 'Monthly Salary',
      amount: 10000,
      date: DateTime(2025, 11, 1),
      categoryEntity: category2,
      isIncome: true,
    ),
  ];

  test('filters by category', () {
    final result = FilterTransactionsUseCase.filterTransactions(transactions, categoryId: 'cat1');
    expect(result.length, 1);
    expect(result[0].categoryEntity.id, 'cat1');
  });

  test('filters by income', () {
    final result = FilterTransactionsUseCase.filterTransactions(transactions, incomeFilter: true);
    expect(result.length, 1);
    expect(result[0].isIncome, true);
  });

  test('filters by expense', () {
    final result = FilterTransactionsUseCase.filterTransactions(transactions, incomeFilter: false);
    expect(result.length, 1);
    expect(result[0].isIncome, false);
  });

  test('filters by date', () {
    final date = DateTime(2025, 11, 2);
    final result = FilterTransactionsUseCase.filterTransactions(transactions, dateFilter: date);
    expect(result.length, 1);
    expect(result[0].date, date);
  });

  test('returns all when no filters provided', () {
    final result = FilterTransactionsUseCase.filterTransactions(transactions);
    expect(result.length, 2);
  });
}
