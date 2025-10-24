import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String userId, String categoryId);
  Future<List<CategoryEntity>> getCategories(String userId);

  Future<void> addDefaultCategories(String userId);
}

