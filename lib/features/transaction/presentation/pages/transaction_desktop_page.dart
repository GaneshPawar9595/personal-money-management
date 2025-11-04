import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../config/localization/app_localizations.dart'; // Adjust path if needed
import '../../domain/entities/transaction_entity.dart';
import '../provider/transaction_provider.dart';
import '../utils/delete_dialogs.dart';
import '../utils/transaction_filter.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_search_filter_bar.dart';

class TransactionDesktopPage extends StatefulWidget {
  final String userId;

  const TransactionDesktopPage({super.key, required this.userId});

  @override
  State<TransactionDesktopPage> createState() => TransactionDesktopPageState();
}

class TransactionDesktopPageState extends State<TransactionDesktopPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _showOnlyIncome = false;
  bool _showOnlyExpense = false;
  TransactionEntity? _selectedTransaction;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _clearSelectedTransaction();
      });
    });

    // Load transactions the first time the page appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      if (provider.transactions.isEmpty) {
        provider.loadTransactions(widget.userId);
      }
    });
  }

  void _onFilterSelected(String val) {
    setState(() {
      _showOnlyIncome = val == "Income";
      _showOnlyExpense = val == "Expense";
      if (val == "All") {
        _showOnlyIncome = false;
        _showOnlyExpense = false;
      }
      _clearSelectedTransaction();
    });
  }

  Future<void> _confirmDelete(TransactionEntity transaction) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDeleteConfirmationDialog(context, transaction.note);
    if (confirmed == true) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      await provider.deleteTransaction(widget.userId, transaction.id);
      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.translate('failed_to_delete_transaction')}: ${provider.error}')),
        );
      } else if (_selectedTransaction?.id == transaction.id) {
        _clearSelectedTransaction();
      }
    }
  }

  void _clearSelectedTransaction() {
    setState(() {
      _selectedTransaction = null;
    });
  }

  Widget _buildTopBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            loc.translate('transaction'),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('${loc.translate('error')}: ${provider.error}'));
          }

          final filteredTransactions = filterTransactions(
            provider.transactions,
            _searchQuery,
            _showOnlyIncome,
            _showOnlyExpense,
          );

          return Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          TransactionSearchFilterBar(
                            controller: _searchController,
                            showOnlyIncome: _showOnlyIncome,
                            showOnlyExpense: _showOnlyExpense,
                            onSearchChanged: (val) => setState(() => _searchQuery = val),
                            onFilterSelected: _onFilterSelected,
                          ),
                          Expanded(
                            child: TransactionList(
                              transactions: filteredTransactions,
                              onTap: (transaction) => setState(() => _selectedTransaction = transaction),
                              onLongPress: _confirmDelete,
                              selectedTransaction: _selectedTransaction,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: _clearSelectedTransaction,
                              icon: const Icon(Icons.clear),
                              label: Text(loc.translate('clear_selection_label')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TransactionForm(
                          userId: widget.userId,
                          closeOnSubmit: false,
                          existingTransaction: _selectedTransaction,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}