import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import 'transaction_remote_datasource.dart';

/// Implementation of [CategoryRemoteDataSource] using Firestore as backend.
///
/// Responsible for performing Firestore CRUD operations related to categories.
/// Supports batch addition of default categories on initial setup.
class TransactionRemoteDataSourceImpl implements TransactionRemoteDatasource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl(this.firestore);

  /// Deletes a transaction document by user ID and transaction ID.
  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    await firestore
        .collection('transactions')
        .doc(userId)
        .collection('list')
        .doc(transactionId)
        .delete();
  }

  /// Retrieves all transaction documents for a given user.
  /// Maps Firestore documents to [TransactionModel] instances.
  @override
  Future<List<TransactionModel>> getTransaction(String userId) async {
    final snapshot = await firestore
        .collection('transactions')
        .doc(userId)
        .collection('list')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Inject document ID into model JSON
      return TransactionModel.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addTransaction(String userId, TransactionModel transactionEntity) async {
    await firestore
        .collection('transactions')
        .doc(userId)
        .collection('list')
        .doc(transactionEntity.id)
        .set(transactionEntity.toJson());
  }

  @override
  Future<void> updateTransaction(String userId, TransactionModel transactionEntity) async {
    await firestore
        .collection('transactions')
        .doc(userId)
        .collection('list')
        .doc(transactionEntity.id)
        .update(transactionEntity.toJson());
  }

}
