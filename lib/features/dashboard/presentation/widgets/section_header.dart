import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable section header with optional "View All" link
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onViewAll;
  final String viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.onViewAll,
    this.viewAllText = 'View All',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                viewAllText,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
