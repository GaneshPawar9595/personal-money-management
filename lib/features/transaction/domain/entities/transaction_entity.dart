import 'package:equatable/equatable.dart';
import '../../../category/domain/entities/category_entity.dart';

/// Represents a financial transaction associated with a user category.
///
/// Contains details such as:
/// - Unique identifier [id]
/// - Optional [note] describing the transaction
/// - [amount] of the transaction (positive value)
/// - Date/time when the transaction occurred [date]
/// - The related [categoryEntity] categorizing the transaction
/// - A flag [isIncome] to distinguish income from expenses
class TransactionEntity extends Equatable {
  final String id;
  final String note;
  final double amount;
  final DateTime date;
  final CategoryEntity categoryEntity;
  final bool isIncome;

  const TransactionEntity({
    required this.id,
    required this.note,
    required this.amount,
    required this.date,
    required this.categoryEntity,
    required this.isIncome,
  });

  // Overriding equality props to enable correct comparison,
  // excluding any UI widgets or non-essential fields.
  @override
  List<Object?> get props => [id, note, amount, date, categoryEntity, isIncome];
}
