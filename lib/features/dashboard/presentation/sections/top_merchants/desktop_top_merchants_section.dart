import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/localization/app_localizations.dart';
import 'top_merchants_section.dart';

/// Desktop top merchants with enhanced card layout
class DesktopTopMerchantsSection extends StatelessWidget {
  final String userId;

  const DesktopTopMerchantsSection({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Icon(
                  Icons.store,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  loc.translate('top_merchants_title'),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            TopMerchantsSection(userId: userId, crossAxisItemCount: 3,),
          ],
        ),
      ),
    );
  }
}
