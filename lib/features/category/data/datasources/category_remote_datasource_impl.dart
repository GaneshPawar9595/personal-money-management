import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import 'category_remote_datasource.dart';
import '../../../../core/utils/default_categories.dart';

/// Implementation of [CategoryRemoteDataSource] using Firestore as backend.
///
/// Responsible for performing Firestore CRUD operations related to categories.
/// Supports batch addition of default categories on initial setup.
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl(this.firestore);

  /// Adds a new category document under the user's sub-collection.
  @override
  Future<void> addCategory(CategoryModel category) async {
    await firestore
        .collection('categories')
        .doc(category.userId)
        .collection('list')
        .doc(category.id)
        .set(category.toJson());
  }

  /// Updates an existing category document.
  /// Throws if document does not exist.
  @override
  Future<void> updateCategory(CategoryModel category) async {
    await firestore
        .collection('categories')
        .doc(category.userId)
        .collection('list')
        .doc(category.id)
        .update(category.toJson());
  }

  /// Deletes a category document by user ID and category ID.
  @override
  Future<void> deleteCategory(String userId, String categoryId) async {
    await firestore
        .collection('categories')
        .doc(userId)
        .collection('list')
        .doc(categoryId)
        .delete();
  }

  /// Retrieves all category documents for a given user.
  /// Maps Firestore documents to [CategoryModel] instances.
  @override
  Future<List<CategoryModel>> getCategories(String userId) async {
    final snapshot = await firestore
        .collection('categories')
        .doc(userId)
        .collection('list')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Inject document ID into model JSON
      return CategoryModel.fromJson(data);
    }).toList();
  }

  /// Adds a default set of categories for a new user in batch.
  /// Only executes if the user has no existing categories.
  @override
  Future<void> addDefaultCategories(String userId) async {
    final collectionRef = firestore.collection('categories').doc(userId).collection('list');

    // Query to check if at least one category exists for efficiency
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      // No categories found, proceed with batch insert of default categories
      final batch = firestore.batch();
      final defaultCategories = getDefaultCategories(userId);

      for (final category in defaultCategories) {
        final docRef = collectionRef.doc(category.id);
        batch.set(docRef, CategoryModel.fromEntity(category).toJson());
      }

      // Commit batch write
      await batch.commit();
    }
  }
}
