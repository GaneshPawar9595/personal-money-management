import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String note) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Transaction'),
      content: Text('Are you sure you want to delete the transaction "$note"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );
}
