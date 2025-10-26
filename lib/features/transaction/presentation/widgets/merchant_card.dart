import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_management/features/transaction/presentation/widgets/transaction_form.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class MerchantCard extends StatelessWidget {
  final CategoryEntity category;
  final double amount;
  final int count;
  final String userId;

  const MerchantCard({
    super.key,
    required this.category,
    required this.amount,
    required this.count,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color;
    final icon = category.iconData;

    return GestureDetector(
      onTap: () {
        _showMerchantTransactions(context, category.name, userId);
      },
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha:0.12),
                child: Icon(icon, color: color, size: 28),
              ),
              Column(
                children: [
                  Text(
                    '₹${NumberFormat.compact().format(amount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count Transactions',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMerchantTransactions(BuildContext context, String category, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: SizedBox(
                    width: 40,
                    height: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Transactions for $category",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Consumer<TransactionProvider>(
                    builder: (context, provider, _) {
                      final categoryTxns = provider.transactions
                          .where((t) => t.categoryEntity.name == category)
                          .toList();

                      if (categoryTxns.isEmpty) {
                        return Center(
                          child: Text(
                            "No transactions found.",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: categoryTxns.length,
                        itemBuilder: (context, index) {
                          final transaction = categoryTxns[index];
                          final iconColor = transaction.categoryEntity.color;
                          final iconData = transaction.categoryEntity.iconData;

                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: transaction.isIncome
                                    ? Colors.greenAccent.shade100
                                    : Colors.white38,
                                child: Icon(
                                  iconData,
                                  color: iconColor,
                                ),
                              ),
                              title: Text(
                                transaction.categoryEntity.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                transaction.note,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹ ${transaction.amount.toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: transaction.isIncome
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d MMM')
                                        .format(transaction.date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => TransactionForm(
                                    existingTransaction: transaction,
                                    userId: userId,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
