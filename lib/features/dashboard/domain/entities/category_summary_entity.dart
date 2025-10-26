import '../../../category/domain/entities/category_entity.dart'; // Brings in the “category card” (like Food, Travel) used across the app. [web:101][web:104]

/// This is a simple bundle of numbers for one spending category,
/// so dashboards can show “how much,” “how many transactions,” and “what percent” it is. [web:101][web:104]
class CategorySummaryEntity {
  /// Which category these numbers belong to (for example: Food or Travel). [web:101][web:104]
  final CategoryEntity category; // [web:101][web:104]

  /// Total money spent in this category. [web:101][web:104]
  final double amount; // [web:101][web:104]

  /// How many transactions happened in this category. [web:101][web:104]
  final int transactionCount; // [web:101][web:104]

  /// What percentage of all spending this category represents (0.0 to 100.0). [web:101][web:104]
  final double percentage; // [web:101][web:104]

  /// Creates this summary; everything is fixed after creation to keep numbers consistent. [web:101][web:104]
  const CategorySummaryEntity({
    required this.category,
    required this.amount,
    required this.transactionCount,
    this.percentage = 0.0,
  }); // [web:101][web:104]

  /// Makes a copy with only the fields you want to change; useful when updating just one number. [web:101][web:104]
  CategorySummaryEntity copyWith({
    CategoryEntity? category,
    double? amount,
    int? transactionCount,
    double? percentage,
  }) {
    return CategorySummaryEntity(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      transactionCount: transactionCount ?? this.transactionCount,
      percentage: percentage ?? this.percentage,
    ); // [web:101][web:104]
  }

  /// Two summaries are considered the same if they refer to the same category (by id)
  /// and all their numbers match. This helps lists and charts avoid duplicates. [web:113][web:115]
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategorySummaryEntity &&
              runtimeType == other.runtimeType &&
              category.id == other.category.id &&
              amount == other.amount &&
              transactionCount == other.transactionCount &&
              percentage == other.percentage; // [web:113][web:115]

  /// Generates a number that goes along with equality so sets/maps work correctly. [web:115][web:116]
  @override
  int get hashCode =>
      category.id.hashCode ^
      amount.hashCode ^
      transactionCount.hashCode ^
      percentage.hashCode; // [web:115][web:116]
}
