import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

/// Repository implementation for transaction data.
///
/// Acts as a bridge between domain layer and remote data source,
/// converting domain entities to data models and vice versa,
/// abstracting remote calls.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDataSource;

  // Constructor with semicolon
  TransactionRepositoryImpl (this.remoteDataSource);

  /// Adds a new transaction by converting the domain entity to a model
  /// and delegating to the remote data source.
  @override
  Future<void> addTransaction(String userId, TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDataSource.addTransaction(userId, model);
  }

  /// Updates an existing transaction by converting domain entity to model
  /// then delegating to remote data source.
  @override
  Future<void> updateTransaction(String userId, TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDataSource.updateTransaction(userId, model);
  }

  /// Deletes a transaction by user ID and transaction ID.
  /// Delegates deletion to remote data source.
  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    await remoteDataSource.deleteTransaction(userId, transactionId);
  }

  /// Retrieves a list of transactions for a user,
  /// converts models to domain entities before returning.
  @override
  Future<List<TransactionEntity>> getTransaction(String userId) async {
    final models = await remoteDataSource.getTransaction(userId);
    return models.map((m) => m.toEntity()).toList();
  }
}
