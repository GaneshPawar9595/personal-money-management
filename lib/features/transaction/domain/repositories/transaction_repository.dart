import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(String userId, TransactionEntity transactionEntity);
  Future<void> updateTransaction(String userId, TransactionEntity transactionEntity);
  Future<void> deleteTransaction(String userId, String transactionEntityID);
  Future<List<TransactionEntity>> getTransaction(String userId);
}
