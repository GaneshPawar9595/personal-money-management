import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';

import '../repositories/transaction_repository.dart';

class GetTransactionUseCase {
  final TransactionRepository repository;

  GetTransactionUseCase(this.repository);

  Future<List<TransactionEntity>> call(String userId) async {
    return await repository.getTransaction(userId);
  }


}