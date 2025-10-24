import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String userId, String categoryId);
  Future<List<CategoryModel>> getCategories(String userId);

  Future<void> addDefaultCategories(String userId);
}
