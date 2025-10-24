import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

/// Repository implementation for category data.
///
/// This class acts as a bridge between domain layer and remote datasource.
/// It converts domain entities to data models and vice versa, abstracting remote calls.
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  /// Adds a new category by converting the domain entity to a model
  /// and delegating the operation to the remote data source.
  @override
  Future<void> addCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    await remoteDataSource.addCategory(model);
  }

  /// Updates an existing category similarly by model conversion
  /// and passing it to remote data source.
  @override
  Future<void> updateCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    await remoteDataSource.updateCategory(model);
  }

  /// Deletes a category given the user ID and category ID.
  /// Directly hands off to the remote data source.
  @override
  Future<void> deleteCategory(String userId, String categoryId) async {
    await remoteDataSource.deleteCategory(userId, categoryId);
  }

  /// Retrieves a list of category models from remote datasource,
  /// then converts them to domain entities before returning.
  @override
  Future<List<CategoryEntity>> getCategories(String userId) async {
    final models = await remoteDataSource.getCategories(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  /// Adds default categories for a new user by forwarding to remote data source.
  @override
  Future<void> addDefaultCategories(String userId) {
    return remoteDataSource.addDefaultCategories(userId);
  }
}
