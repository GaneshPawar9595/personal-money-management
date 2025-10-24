import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';

typedef TransactionTapCallback = void Function(TransactionEntity transaction);
typedef TransactionLongPressCallback = void Function(TransactionEntity transaction);

class TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final TransactionTapCallback onTap;
  final TransactionLongPressCallback onLongPress;
  final TransactionEntity? selectedTransaction;
  final bool showHeaders;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onTap,
    required this.onLongPress,
    this.selectedTransaction,
    this.showHeaders = true,
  });

  /// Groups and sorts transactions by date
  List<Map<String, dynamic>> groupTransactionsByDate(List<TransactionEntity> transactions) {
    // Sort newest first
    transactions.sort((a, b) => b.date.compareTo(a.date));

    List<Map<String, dynamic>> groupedList = [];
    String lastDate = "";

    for (var transaction in transactions) {
      final displayDate = getDisplayDate(transaction.date);
      // Add a header if date changed
      if (displayDate != lastDate) {
        groupedList.add({"type": "header", "date": displayDate});
        lastDate = displayDate;
      }
      groupedList.add({"type": "transaction", "data": transaction});
    }
    return groupedList;
  }

  /// Returns date labels like Today, Yesterday, Weekdays, etc.
  String getDisplayDate(DateTime transactionDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transDate = DateTime(transactionDate.year, transactionDate.month, transactionDate.day);
    final daysDifference = today.difference(transDate).inDays;

    if (daysDifference == 0) return "Today";
    if (daysDifference == 1) return "Yesterday";
    if (daysDifference < 7) return DateFormat.EEEE().format(transactionDate);
    return DateFormat('dd MMM yyyy').format(transactionDate);
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }

    final groupedTransactions = groupTransactionsByDate(transactions);

    return ListView.builder(
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final item = groupedTransactions[index];

        if (item["type"] == "header" ) {
          if (!showHeaders) return const SizedBox.shrink();
          // Date header
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              item["date"],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          );
        }

        final transaction = item["data"] as TransactionEntity;
        final isSelected = selectedTransaction?.id == transaction.id;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isSelected
                  ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            elevation: isSelected ? 6 : 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: Icon(
                transaction.categoryEntity.iconData,
                color: transaction.categoryEntity.color,
              ),
              title: Text(
                transaction.categoryEntity.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: transaction.note.isNotEmpty
                  ? Text(
                transaction.note,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              )
                  : null,
              trailing: Text(
                "₹ ${transaction.amount.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome ? Colors.green : Colors.red,
                ),
              ),
              onTap: () => onTap(transaction),
              onLongPress: () => onLongPress(transaction),
            ),
          ),
        );
      },
    );
  }
}
