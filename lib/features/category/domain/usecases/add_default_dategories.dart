import '../repositories/category_repository.dart';

class AddDefaultCategoriesUseCase {
  final CategoryRepository repository;

  AddDefaultCategoriesUseCase(this.repository);

  Future<void> execute(String userId) {
    return repository.addDefaultCategories(userId);
  }
}
