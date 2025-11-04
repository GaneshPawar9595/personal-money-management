import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_management/features/transaction/domain/entities/transaction_entity.dart';
import '../../../../../config/localization/app_localizations.dart'; // adjust path

typedef TransactionTapCallback = void Function(TransactionEntity transaction);
typedef TransactionLongPressCallback = void Function(TransactionEntity transaction);

class TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final TransactionTapCallback onTap;
  final TransactionLongPressCallback onLongPress;
  final TransactionEntity? selectedTransaction;
  final bool showHeaders;
  final ScrollPhysics? scrollPhysics;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onTap,
    required this.onLongPress,
    this.selectedTransaction,
    this.showHeaders = true,
    this.scrollPhysics,
  });

  /// Groups and sorts transactions by date
  List<Map<String, dynamic>> groupTransactionsByDate(
      List<TransactionEntity> transactions,
      AppLocalizations loc,
      ) {
    transactions.sort((a, b) => b.date.compareTo(a.date));

    List<Map<String, dynamic>> groupedList = [];
    String lastDate = "";

    for (var transaction in transactions) {
      final displayDate = getDisplayDate(transaction.date, loc);
      if (displayDate != lastDate) {
        groupedList.add({"type": "header", "date": displayDate});
        lastDate = displayDate;
      }
      groupedList.add({"type": "transaction", "data": transaction});
    }
    return groupedList;
  }

  /// Returns date labels like Today, Yesterday, Weekdays, etc. (localized!)
  String getDisplayDate(DateTime transactionDate, AppLocalizations loc) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transDate = DateTime(transactionDate.year, transactionDate.month, transactionDate.day);
    final daysDifference = today.difference(transDate).inDays;

    if (daysDifference == 0) return loc.translate('today');
    if (daysDifference == 1) return loc.translate('yesterday');
    if (daysDifference < 7) return DateFormat.EEEE().format(transactionDate);
    return DateFormat('dd MMM yyyy').format(transactionDate); // Format based on locale if needed
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          loc.translate('no_transactions_found'),
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }

    final groupedTransactions = groupTransactionsByDate(transactions, loc);

    return ListView.builder(
      itemCount: groupedTransactions.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = groupedTransactions[index];

        if (item["type"] == "header") {
          if (!showHeaders) return const SizedBox.shrink();
          // Date header
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side:
              isSelected
                  ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
                  : BorderSide.none,
            ),
            elevation: isSelected ? 6 : 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
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
              subtitle:
              transaction.note.isNotEmpty
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
