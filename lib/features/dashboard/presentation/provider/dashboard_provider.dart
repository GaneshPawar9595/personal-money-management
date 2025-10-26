import 'package:flutter/foundation.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../domain/entities/category_summary_entity.dart';
import '../../domain/entities/spending_trend_entity.dart';
import '../../domain/usecases/calculate_category_summary_usecase.dart';
import '../../domain/usecases/calculate_spending_trends_usecase.dart';
import '../../domain/usecases/get_recent_transactions_usecase.dart';

/// Centralized provider for dashboard calculations and state
/// Separates business logic from UI components
class DashboardProvider extends ChangeNotifier {
  // Use cases
  final CalculateCategorySummaryUseCase _categorySummaryUseCase;
  final CalculateSpendingTrendsUseCase _spendingTrendsUseCase;
  final GetRecentTransactionsUseCase _recentTransactionsUseCase;

  // State
  List<TransactionEntity> _transactions = [];
  TimeRange _selectedMerchantsRange = TimeRange.monthly;
  TimeRange _selectedTrendsRange = TimeRange.monthly;
  TimeRange _selectedCategoryRange = TimeRange.monthly; // ✅ NEW: For category breakdown

  // Cached calculations (recalculated when transactions or filters change)
  List<CategorySummaryEntity>? _cachedCategorySummary;
  List<CategorySummaryEntity>? _cachedMerchantSummary;
  List<SpendingTrendEntity>? _cachedSpendingTrends;
  List<TransactionEntity>? _cachedRecentTransactions;

  DashboardProvider({
    CalculateCategorySummaryUseCase? categorySummaryUseCase,
    CalculateSpendingTrendsUseCase? spendingTrendsUseCase,
    GetRecentTransactionsUseCase? recentTransactionsUseCase,
  })  : _categorySummaryUseCase =
      categorySummaryUseCase ?? CalculateCategorySummaryUseCase(),
        _spendingTrendsUseCase =
            spendingTrendsUseCase ?? CalculateSpendingTrendsUseCase(),
        _recentTransactionsUseCase =
            recentTransactionsUseCase ?? GetRecentTransactionsUseCase();

  // Getters
  List<TransactionEntity> get transactions => _transactions;
  TimeRange get selectedMerchantsRange => _selectedMerchantsRange;
  TimeRange get selectedTrendsRange => _selectedTrendsRange;
  TimeRange get selectedCategoryRange => _selectedCategoryRange; // ✅ NEW

  /// Updates transactions and invalidates cache
  void setTransactions(List<TransactionEntity> transactions) {
    _transactions = transactions;
    _invalidateCache();
    notifyListeners();
  }

  /// Updates merchants time range filter
  void setMerchantsRange(TimeRange range) {
    if (_selectedMerchantsRange == range) return;
    _selectedMerchantsRange = range;
    _cachedMerchantSummary = null; // Invalidate only merchant cache
    notifyListeners();
  }

  /// Updates spending trends time range filter
  void setTrendsRange(TimeRange range) {
    if (_selectedTrendsRange == range) return;
    _selectedTrendsRange = range;
    _cachedSpendingTrends = null; // Invalidate only trends cache
    notifyListeners();
  }

  /// ✅ NEW: Updates category breakdown time range filter
  void setCategoryRange(TimeRange range) {
    if (_selectedCategoryRange == range) return;
    _selectedCategoryRange = range;
    _cachedCategorySummary = null; // Invalidate category cache
    notifyListeners();
  }

  /// Gets recent transactions (cached)
  List<TransactionEntity> getRecentTransactions({int limit = 3}) {
    _cachedRecentTransactions ??= _recentTransactionsUseCase(
      transactions: _transactions,
      limit: limit,
    );
    return _cachedRecentTransactions!;
  }

  /// ✅ UPDATED: Gets category spending summary with percentages (cached)
  /// Now filtered by selected time range
  List<CategorySummaryEntity> getCategorySummary() {
    _cachedCategorySummary ??= _getCategorySummaryForRange();
    return _cachedCategorySummary!;
  }

  /// ✅ NEW: Calculates category summary based on selected time range
  List<CategorySummaryEntity> _getCategorySummaryForRange() {
    final now = DateTime.now();
    DateTime? startDate;

    switch (_selectedCategoryRange) {
      case TimeRange.weekly:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.monthly:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimeRange.yearly:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    return _categorySummaryUseCase(
      transactions: _transactions,
      startDate: startDate,
      calculatePercentage: true,
    );
  }

  /// Gets total spending amount
  double getTotalSpending() {
    final summary = getCategorySummary();
    return summary.fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Gets top category summary (highest spending)
  CategorySummaryEntity? getTopCategory() {
    final summary = getCategorySummary();
    return summary.isNotEmpty ? summary.first : null;
  }

  /// Gets merchant summary filtered by time range (cached per range)
  List<CategorySummaryEntity> getMerchantSummary() {
    _cachedMerchantSummary ??= _getMerchantSummaryForRange();
    return _cachedMerchantSummary!;
  }

  /// Calculates merchant summary based on selected time range
  List<CategorySummaryEntity> _getMerchantSummaryForRange() {
    final now = DateTime.now();
    DateTime? startDate;

    switch (_selectedMerchantsRange) {
      case TimeRange.weekly:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.monthly:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimeRange.yearly:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    return _categorySummaryUseCase(
      transactions: _transactions,
      startDate: startDate,
      calculatePercentage: false,
    );
  }

  /// Gets spending trends (cached per range)
  List<SpendingTrendEntity> getSpendingTrends() {
    _cachedSpendingTrends ??= _spendingTrendsUseCase(
      transactions: _transactions,
      timeRange: _selectedTrendsRange,
    );
    return _cachedSpendingTrends!;
  }

  /// Calculates percentage change in spending trends
  double getSpendingPercentageChange() {
    final trends = getSpendingTrends();
    return _spendingTrendsUseCase.calculatePercentageChange(trends);
  }

  /// Gets all possible keys for current trends range (for chart display)
  List<int> getAllTrendsKeys() {
    return _spendingTrendsUseCase.getAllKeysForRange(_selectedTrendsRange);
  }

  /// Invalidates all cached calculations
  void _invalidateCache() {
    _cachedCategorySummary = null;
    _cachedMerchantSummary = null;
    _cachedSpendingTrends = null;
    _cachedRecentTransactions = null;
  }

  /// Clears all data
  void clear() {
    _transactions = [];
    _invalidateCache();
    notifyListeners();
  }
}
