import 'package:flutter/material.dart';
import 'package:money_management/features/transaction/presentation/widgets/transaction_form.dart';
import '../../domain/entities/transaction_entity.dart';

/// Helper method to display the add/edit category form adapting to device UX.
///
/// Currently implemented for mobile devices as a modal bottom sheet.
/// Can be extended to support dialogs or other presentations on tablets or desktop.
///
/// Parameters:
/// - [context]: BuildContext to display the form in.
/// - [userId]: The current user ID, used to load/save category data.
/// - [category]: Optional category entity to edit; null for creating a new category.
Future<void> showTransactionForm(
    BuildContext context,
    String userId,
    TransactionEntity? transaction,
    ) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows sheet to adjust to keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TransactionForm(
        userId: userId,
        existingTransaction: transaction,
        closeOnSubmit: true,
      ),
    ),
  );
}
