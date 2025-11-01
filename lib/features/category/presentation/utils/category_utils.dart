import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/localization/app_localizations.dart';
import '../../domain/entities/category_entity.dart';
import '../provider/category_provider.dart';

Future<void> confirmDeleteCategory(
  BuildContext context,
  String userId,
  CategoryEntity category,
) async {
  final loc = AppLocalizations.of(context); // Get this BEFORE await
  final scaffoldMessenger = ScaffoldMessenger.of(context); // Get before await
  final provider = Provider.of<CategoryProvider>(
    context,
    listen: false,
  ); // Get before await

  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text(loc!.translate('delete_category_title')),
          content: Text(
            loc.translate('delete_category_message', args: [category.name]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(loc.translate('cancel_button')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(loc.translate('delete_button')),
            ),
          ],
        ),
  );

  // If used in a State class, check if (context as Element).mounted or use a callback
  if (confirmed == true) {
    await provider.deleteCategory(userId, category.id);

    if (provider.error != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            loc!.translate('category_delete_failed', args: [provider.error!]),
          ),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(loc!.translate('category_deleted_success'))),
      );
    }
  }
}
