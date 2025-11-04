import 'package:flutter/material.dart';
import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:money_management/features/transaction/domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_today_amount_status_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';

/// Provider managing transactions data and state.
///
/// Responsibilities include:
/// - Loading, adding, updating, deleting transactions
/// - Handling loading and error states
/// - Notifying UI about state changes
class TransactionProvider extends ChangeNotifier {
  final AddTransactionUseCase addTransactionUseCase;
  final GetTransactionUseCase getTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  // List of transactions for the logged-in user
  List<TransactionEntity> _transactions = [];
  List<TransactionEntity> get transactions => _transactions;

  // Loading indicator for UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message if any operation fails
  String? _error;
  String? get error => _error;

  TransactionProvider({
    required this.addTransactionUseCase,
    required this.getTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
  });

  /// Internal helper to update loading state safely
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Internal helper to record and notify errors
  void _setError(String message) {
    _error = message;
    debugPrint(message); // Log error for debugging
    notifyListeners();
  }

  /// Fetches transactions for a specific user and updates state
  Future<void> loadTransactions(String userId) async {
    _setLoading(true);
    try {
      _transactions = await getTransactionUseCase.call(userId);
      _error = null;
    } catch (e) {
      _setError('Failed to load transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds a new transaction and updates the local state on success
  Future<void> addTransaction(
    String userId,
    TransactionEntity transaction,
  ) async {
    try {
      await addTransactionUseCase.call(userId, transaction);
      _transactions.add(transaction);
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to add transaction: $e');
    }
  }

  /// Updates an existing transaction and refreshes local state accordingly
  Future<void> updateTransaction(
    String userId,
    TransactionEntity transaction,
  ) async {
    try {
      await updateTransactionUseCase.call(userId, transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update transaction: $e');
    }
  }

  /// Deletes a transaction by userId and transactionId, updates local state
  Future<void> deleteTransaction(String userId, String transactionId) async {
    try {
      await deleteTransactionUseCase.call(userId, transactionId);
      _transactions.removeWhere(
        (transaction) => transaction.id == transactionId,
      );
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete transaction: $e');
    }
  }

  // Total Balance
  double getTotalAmount() {
    return _transactions.fold(0.0, (sum, t) => sum + (t.isIncome ? t.amount : -t.amount));
  }

  /// Example: Calculate today's amount status using a dedicated use case or utility
  double getTodayAmountStatus() {
    return GetTodayAmountStatusUseCase.getTodayAmountStatus(_transactions);
  }

}
