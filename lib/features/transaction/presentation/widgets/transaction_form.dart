import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/custom_input_field.dart';
import '../../../category/presentation/widgets/category_dropdown.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../provider/transaction_provider.dart';

import 'date_selector_widget.dart';
import 'income_expense_switch.dart';

class TransactionForm extends StatefulWidget {
  final String userId;
  final TransactionEntity? existingTransaction;
  final bool? closeOnSubmit;

  const TransactionForm({
    super.key,
    required this.userId,
    this.existingTransaction,
    this.closeOnSubmit,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  late TextEditingController _noteController;
  bool isIncome = false;
  DateTime selectedDate = DateTime.now();
  CategoryEntity? selectedCategory;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.existingTransaction?.amount.toString() ?? '');
    _noteController = TextEditingController(
        text: widget.existingTransaction?.note ?? '');
    isIncome = widget.existingTransaction?.isIncome ?? false;
    selectedDate = widget.existingTransaction?.date ?? DateTime.now();
    selectedCategory = widget.existingTransaction?.categoryEntity;
  }

  @override
  void didUpdateWidget(covariant TransactionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.existingTransaction != widget.existingTransaction) {
      _amountController.text =
          widget.existingTransaction?.amount.toString() ?? '';
      _noteController.text = widget.existingTransaction?.note ?? '';
      isIncome = widget.existingTransaction?.isIncome ?? false;
      selectedDate = widget.existingTransaction?.date ?? DateTime.now();
      selectedCategory = widget.existingTransaction?.categoryEntity;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      _showError('Please select a category');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }

    setState(() => _isSubmitting = true);

    final transaction = TransactionEntity(
      id: widget.existingTransaction?.id ?? UniqueKey().toString(),
      amount: amount,
      isIncome: isIncome,
      date: selectedDate,
      categoryEntity: selectedCategory!,
      note: _noteController.text.trim(),
    );

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    try {
      if (widget.existingTransaction == null) {
        await provider.addTransaction(widget.userId, transaction);
      } else {
        await provider.updateTransaction(widget.userId, transaction);
      }

      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.existingTransaction == null
              ? 'Transaction added successfully'
              : 'Transaction updated successfully'),
          backgroundColor: Colors.green,
        ));

        if (widget.closeOnSubmit ?? true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
        }
      } else {
        _showError(provider.error!);
      }
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                widget.existingTransaction == null
                    ? 'Add Transaction'
                    : 'Edit Transaction',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _amountController,
                hintText: 'Enter amount',
                label: 'Amount',
                icon: Icons.currency_rupee,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (val) =>
                (val == null || val.isEmpty) ? 'Amount required' : null,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _noteController,
                hintText: 'Optional note',
                label: 'Note',
                icon: Icons.note,
              ),
              const SizedBox(height: 16),

              IncomeExpenseSwitch(
                isIncome: isIncome,
                onChanged: (value) => setState(() => isIncome = value),
              ),
              const SizedBox(height: 16),

              CategorySelector(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) =>
                    setState(() => selectedCategory = category),
              ),
              const SizedBox(height: 16),

              DateSelector(
                selectedDate: selectedDate,
                onDateSelected: (date) => setState(() => selectedDate = date),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(
                  widget.existingTransaction == null ? 'Add' : 'Update',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
