import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../widgets/category_form.dart';
import '../widgets/category_list.dart';

class CategoryTabletPage extends StatefulWidget {
  final String userId;

  const CategoryTabletPage({super.key, required this.userId});

  @override
  _CategoryTabletPageState createState() => _CategoryTabletPageState();
}

class _CategoryTabletPageState extends State<CategoryTabletPage>  with AutomaticKeepAliveClientMixin<CategoryTabletPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  CategoryEntity? _selectedCategory;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load categories when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      if (provider.categories.isEmpty) {
        provider.loadCategories(widget.userId);
      }
    });

    // Listen to text changes for search filtering
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns list of categories filtered by search term (case insensitive)
  List<CategoryEntity> _filterCategories(List<CategoryEntity> categories) {
    if (_searchTerm.isEmpty) return categories;
    return categories.where((c) => c.name.toLowerCase().contains(_searchTerm)).toList();
  }

  /// Shows confirmation dialog and deletes a category if confirmed
  void _confirmDelete(CategoryEntity category) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
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
        // Clear selection if deleted category was selected
        if (_selectedCategory?.id == category.id) {
          _clearSelectedCategory();
        }
      }
    }
  }

  /// Clears the currently selected category to show empty Add form
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

          return Row(
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
