import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../widgets/category_form.dart';
import '../widgets/category_list.dart';

/// Desktop page for managing categories with a split layout:
/// Left: Search and category list
/// Right: Add/Edit category form
///
/// Consistent with desktop navigation patterns, it can be integrated with
/// NavigationRail as per your dashboard for smooth UX.
class CategoryDesktopPage extends StatefulWidget {
  final String userId;

  const CategoryDesktopPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CategoryDesktopPageState createState() => _CategoryDesktopPageState();
}

class _CategoryDesktopPageState extends State<CategoryDesktopPage>
    with AutomaticKeepAliveClientMixin<CategoryDesktopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  CategoryEntity? _selectedCategory;

  // Keeps page state active when switching tabs (desktop-friendly behavior)
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Load categories when the page opens for the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      if (provider.categories.isEmpty) {
        provider.loadCategories(widget.userId);
      }
    });

    // Listen for text updates in the search bar
    _searchController.addListener(() {
      setState(() {
        // Convert typed text to lowercase for easy matching
        _searchTerm = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    // Clean up resource to avoid memory leaks
    _searchController.dispose();
    super.dispose();
  }

  /// Filters categories by the term user types in the search field.
  /// Returns full list if nothing is typed.
  List<CategoryEntity> _filterCategories(List<CategoryEntity> categories) {
    if (_searchTerm.isEmpty) return categories;
    return categories
        .where((c) => c.name.toLowerCase().contains(_searchTerm))
        .toList();
  }

  /// Opens a confirmation dialog when the user tries to delete a category.
  /// On confirmation, it removes the category from the database and updates state.
  void _confirmDelete(CategoryEntity category) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Delete Category'),
            content: Text(
              'Are you sure you want to delete "${category.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    // Proceed only if user confirmed delete action
    if (confirmed == true) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      await provider.deleteCategory(widget.userId, category.id);
      if (provider.error != null) {
        // Show pop-up message for deletion failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete category: ${provider.error}'),
          ),
        );
      } else {
        // If the deleted item was selected, clear the form on the right panel
        if (_selectedCategory?.id == category.id) {
          _clearSelectedCategory();
        }
      }
    }
  }

  /// Clears the selected category to show an empty “Add Category” form on the right.
  void _clearSelectedCategory() {
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin
    return Scaffold(
      // Consider embedding this page into a desktop layout with NavigationRail
      /*
      If your dashboard uses NavigationRail, integrate this page as a body or nested page.
      The NavigationRail manages navigation selection and actions. This page manages content.
      */
      appBar: AppBar(title: const Text('Categories')),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final filteredCategories = _filterCategories(provider.categories);

          // If there are no categories, show an empty state message
          if (filteredCategories.isEmpty) {
            return Center(
              child: Text(
                'No categories found.\nUse the form on the right to create one.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return Row(
            // LEFT PANEL — Category list with search
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search categories...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon:
                              _searchTerm.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _searchController.clear(),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    // Category list with callbacks
                    Expanded(
                      child: CategoryList(
                        categories: filteredCategories,
                        onTap: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        onLongPress: _confirmDelete,
                        selectedCategory: _selectedCategory,
                      ),
                    ),
                    // Clear selection button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: _clearSelectedCategory,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Selection'),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Flexible(
                flex: 4,
                child: CategoryForm(
                  userId: widget.userId,
                  existingCategory: _selectedCategory,
                  closeOnSubmit: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
