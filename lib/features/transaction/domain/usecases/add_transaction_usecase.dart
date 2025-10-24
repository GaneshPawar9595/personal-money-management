import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';

import '../repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(String userId, TransactionEntity transaction) async {
    return await repository.addTransaction(userId, transaction);
  }
}