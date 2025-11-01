import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/localization/app_localizations.dart';
import '../provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../utils/category_utils.dart';
import '../widgets/category_list.dart';
import '../widgets/category_form_wrapper.dart';

/// Mobile user interface for category management.
///
/// Allows the user to:
/// - View their category list
/// - Search for a category
/// - Add a new category
/// - Delete existing categories
///
/// This page uses a CategoryProvider for state updates
/// and displays feedback via SnackBars.
class CategoryMobilePage extends StatefulWidget {
  final String userId;

  const CategoryMobilePage({super.key, required this.userId});

  @override
  State<CategoryMobilePage> createState() => _CategoryMobilePageState();
}

class _CategoryMobilePageState extends State<CategoryMobilePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();

    // Load all available categories once the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.loadCategories(widget.userId);
    });

    // Update the search term when user types in the search box
    _searchController.addListener(() {
      final newTerm = _searchController.text.trim().toLowerCase();
      if (newTerm != _searchTerm) {
        setState(() => _searchTerm = newTerm);
      }
    });
  }

  @override
  void dispose() {
    // Clean up controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  /// Returns a filtered list of categories that match the search input.
  List<CategoryEntity> _filterCategories(List<CategoryEntity> categories) {
    if (_searchTerm.isEmpty) return categories;
    return categories
        .where((c) => c.name.toLowerCase().contains(_searchTerm))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text(loc!.translate('categories_title')),
        bottom: PreferredSize(
          // Search bar section inside the AppBar
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.translate('category_search_hint'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: _searchTerm.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            // While categories are loading, show a progress spinner
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            // If there was an error during fetch, show the message
            return Center(child: Text('Error: ${provider.error}'));
          }

          final filtered = _filterCategories(provider.categories);

          // Inform user when no categories exist
          if (filtered.isEmpty) {
            return Center(
              child: Text(loc.translate('no_categories_found')),
            );
          }

          // Displays category list with tap and hold interactions
          return CategoryList(
            categories: filtered,
            onTap: (category) => showCategoryForm(context, widget.userId, category),
            onLongPress: (category) => confirmDeleteCategory(context, widget.userId, category),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryForm(context, widget.userId, null),
        tooltip: loc.translate('add_category_tooltip'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
