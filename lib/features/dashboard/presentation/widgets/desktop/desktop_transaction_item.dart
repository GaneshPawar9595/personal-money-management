import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../transaction/domain/entities/transaction_entity.dart';

/// Compact transaction item for desktop sidebar
class DesktopTransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DesktopTransactionItem({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: transaction.categoryEntity.color.withValues(alpha: 0.1),
        child: Icon(
          transaction.categoryEntity.iconData,
          color: transaction.categoryEntity.color,
          size: 20,
        ),
      ),
      title: Text(
        transaction.categoryEntity.name,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.note.isNotEmpty)
            Text(
              transaction.note,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            DateFormat('MMM dd, yyyy').format(transaction.date),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "₹${transaction.amount.toStringAsFixed(2)}",
            style: GoogleFonts.robotoMono(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: transaction.isIncome ? Colors.green : Colors.red,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}
