import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import 'category_mobile_page.dart';
import 'category_tablet_page.dart';
import 'category_desktop_page.dart';

/// CategoryPage is the main entry point for the category feature UI.
/// It uses ResponsiveLayout to automatically choose which layout to show.
/// This adapts the user interface for different screen sizes:
/// - Mobile layout for phones
/// - Tablet layout for medium-sized devices
/// - Desktop layout for large screens or web/desktop platforms
///
/// The [userId] is passed through to each layout to load user-specific data.
class CategoryPage extends StatelessWidget {
  final String userId;

  /// Constructor requires a [userId] to fetch and display categories for that user.
  const CategoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      // Shows mobile UI on small screen widths like phones
      mobileLayout: CategoryMobilePage(userId: userId),

      // Shows tablet-specific UI on medium screen widths like bigger phones or small tablets
      tabletLayout: CategoryTabletPage(userId: userId),

      // Shows full desktop UI on large screen widths such as desktops or web browsers
      desktopLayout: CategoryDesktopPage(userId: userId),
    );
  }
}
