import 'package:money_management/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  Future<void> addTransaction(String userId, TransactionModel transactionEntity);
  Future<void> updateTransaction(String userId, TransactionModel transactionEntity);
  Future<void> deleteTransaction(String userId, String transactionEntityID);
  Future<List<TransactionModel>> getTransaction(String userId);
}
