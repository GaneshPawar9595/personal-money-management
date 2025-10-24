import '../../../category/data/models/category_model.dart';
import '../../domain/entities/transaction_entity.dart';

/// Data model representing a transaction for data sources like Firestore or REST API.
/// Extends [TransactionEntity] and adds JSON serialization/deserialization methods.
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.note,
    required super.amount,
    required super.date,
    required super.categoryEntity,
    required super.isIncome,
  });

  /// Factory method to create a [TransactionModel] from a JSON map.
  /// Expects `category` field as nested JSON object representing the category.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      note: json['note'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      categoryEntity: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      isIncome: json['isIncome'] as bool,
    );
  }

  /// Converts the [TransactionModel] instance to a JSON map.
  /// Serializes the nested [CategoryModel] to JSON as well.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': (categoryEntity as CategoryModel).toJson(),
      'isIncome': isIncome,
    };
  }

  /// Converts a domain [TransactionEntity] to [TransactionModel].
  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      note: entity.note,
      amount: entity.amount,
      date: entity.date,
      categoryEntity: CategoryModel.fromEntity(entity.categoryEntity),
      isIncome: entity.isIncome,
    );
  }

  /// Converts this model back to a domain [TransactionEntity].
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      note: note,
      amount: amount,
      date: date,
      categoryEntity: categoryEntity,
      isIncome: isIncome,
    );
  }
}
