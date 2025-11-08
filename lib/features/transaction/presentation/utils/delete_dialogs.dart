import 'package:flutter/material.dart';
import 'package:money_management/config/localization/app_localizations.dart';

Future<bool?> showDeleteConfirmationDialog(
    BuildContext context,
    String note, {
      String? titleText,
      String? bodyText,
      String? confirmText,
      String? cancelText,
    }) {
  final loc = AppLocalizations.of(context)!;
  // Use provided strings or fallbacks to localization defaults
  final title = titleText ?? loc.translate('delete_dialog_title');
  final body = bodyText ?? loc.translate('delete_dialog_body').replaceAll('{note}', note);
  final confirm = confirmText ?? loc.translate('delete_dialog_confirm');
  final cancel = cancelText ?? loc.translate('delete_dialog_cancel');

  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirm, style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
