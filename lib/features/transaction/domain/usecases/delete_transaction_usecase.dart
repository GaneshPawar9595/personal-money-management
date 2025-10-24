import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> call(String userId, String transactionId) async {
    return await repository.deleteTransaction(userId, transactionId);
  }
}