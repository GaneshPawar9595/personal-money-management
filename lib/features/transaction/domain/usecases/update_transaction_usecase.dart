import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';

import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call(String userId, TransactionEntity transaction) async {
    return await repository.updateTransaction(userId, transaction);
  }
}