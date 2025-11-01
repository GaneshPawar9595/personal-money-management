import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/localization/app_localizations.dart';
import '../../domain/entities/category_entity.dart';

typedef CategoryTapCallback = void Function(CategoryEntity category);
typedef CategoryLongPressCallback = void Function(CategoryEntity category);

/// Displays a scrollable list of categories with interactive tap and long-press handlers.
///
/// The [selectedCategory] parameter highlights the selected item (if any),
/// enhancing usability for desktop and tablet UIs.
///
/// This widget is reusable for all device types (mobile, tablet, desktop).
class CategoryList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final CategoryTapCallback onTap;
  final CategoryLongPressCallback onLongPress;
  final CategoryEntity? selectedCategory;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onTap,
    required this.onLongPress,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (categories.isEmpty) {
      // Show placeholder text when there are no categories
      return Center(child: Text(loc!.translate('no_categories_found')));
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        // Highlight the card if it's the selected category
        final bool isSelected = selectedCategory?.id == category.id;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isSelected
                  ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            elevation: isSelected ? 6 : 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: Icon(category.iconData, color: category.color),
              title: Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                category.message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              onTap: () => onTap(category),
              onLongPress: () => onLongPress(category),
            ),
          ),
        );
      },
    );
  }
}
