import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../top_spend_category_section.dart';

/// Desktop category breakdown with pie chart
class DesktopCategoryBreakdownSection extends StatelessWidget {
  const DesktopCategoryBreakdownSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Icons.pie_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Category Breakdown',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            const TopSpendCategorySection(),
          ],
        ),
      ),
    );
  }
}
