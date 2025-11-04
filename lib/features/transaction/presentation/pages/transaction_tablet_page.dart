import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/localization/app_localizations.dart'; // Adjust this path as needed
import '../../domain/entities/transaction_entity.dart';
import '../provider/transaction_provider.dart';
import '../utils/delete_dialogs.dart';
import '../utils/transaction_filter.dart';
import '../utils/transaction_form_wrapper.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_search_filter_bar.dart';

class TransactionTabletPage extends StatefulWidget {
  final String userId;

  const TransactionTabletPage({super.key, required this.userId});

  @override
  State<TransactionTabletPage> createState() => TransactionTabletPageState();
}

class TransactionTabletPageState extends State<TransactionTabletPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _showOnlyIncome = false;
  bool _showOnlyExpense = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    // Load transactions when the page opens for the first time
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
          SnackBar(
            content: Text('${loc.translate('failed_to_delete_transaction')}: ${provider.error}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('transaction'))),
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

          return Row(
            children: [
              Flexible(
                flex: 3,
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
                        onTap: (transaction) {
                          showTransactionForm(
                            context,
                            widget.userId,
                            transaction,
                          );
                        },
                        onLongPress: _confirmDelete,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTransactionForm(context, widget.userId, null),
        tooltip: loc.translate('add_transaction'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
