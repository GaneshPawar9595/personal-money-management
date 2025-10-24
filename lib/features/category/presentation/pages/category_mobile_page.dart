import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
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
  _CategoryMobilePageState createState() => _CategoryMobilePageState();
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

  /// Prompts the user to confirm deletion, updates provider,
  /// and shows success or failure messages accordingly.
  Future<void> _confirmDelete(CategoryEntity category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      await provider.deleteCategory(widget.userId, category.id);

      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category: ${provider.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: PreferredSize(
          // Search bar section inside the AppBar
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
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
            return const Center(
              child: Text('No categories found. Tap the + button to add a new one.'),
            );
          }

          // Displays category list with tap and hold interactions
          return CategoryList(
            categories: filtered,
            onTap: (category) => showCategoryForm(context, widget.userId, category),
            onLongPress: _confirmDelete,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryForm(context, widget.userId, null),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }
}
