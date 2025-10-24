import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/add_default_dategories.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';

/// The CategoryProvider is responsible for managing the
/// state of category data throughout the application.
///
/// Major responsibilities:
/// - Load, add, update, delete, and initialize user categories
/// - Handle loading state and error messages
/// - Notify listeners (UI) whenever data changes
class CategoryProvider extends ChangeNotifier {
  final AddCategoryUseCase addCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final AddDefaultCategoriesUseCase addDefaultCategoriesUseCase;

  // List of categories for the logged-in user
  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;

  // Loading indicator for UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message (if any)
  String? _error;
  String? get error => _error;

  CategoryProvider({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
    required this.addDefaultCategoriesUseCase,
  });

  /// Loads all categories for the given user.
  /// Displays a progress indicator during fetching.
  Future<void> loadCategories(String userId) async {
    _setLoading(true);
    try {
      _categories = await getCategoriesUseCase.call(userId);
      _error = null;
    } catch (e) {
      _setError('Failed to load categories: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds a new category to both the local list and backend.
  Future<void> addCategory(CategoryEntity category) async {
    try {
      await addCategoryUseCase.call(category);
      _categories.add(category);
      _error = null;
    } catch (e) {
      _setError('Failed to add category: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Updates category details in both local memory and backend.
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      await updateCategoryUseCase.call(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
      _error = null;
    } catch (e) {
      _setError('Failed to update category: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Deletes a category by its ID from backend and updates local list.
  Future<void> deleteCategory(String userId, String categoryId) async {
    try {
      await deleteCategoryUseCase.call(userId, categoryId);
      _categories.removeWhere((c) => c.id == categoryId);
      _error = null;
    } catch (e) {
      _setError('Failed to delete category: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Initializes a new user's default categories.
  /// Typically used for first-time logins or user setup.
  Future<void> initializeUserCategories(String userId) async {
    try {
      await addDefaultCategoriesUseCase.execute(userId);
      await loadCategories(userId); // Refresh list after adding defaults
      _error = null;
    } catch (e) {
      _setError('Failed to initialize default categories: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Helper to set loading flag safely.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Helper to capture and notify error messages.
  void _setError(String message) {
    _error = message;
    debugPrint(message); // For debugging logs
    notifyListeners();
  }
}
