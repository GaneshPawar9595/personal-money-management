import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../config/localization/app_localizations.dart';
import '../provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../utils/category_utils.dart';
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

  const CategoryDesktopPage({super.key, required this.userId});

  @override
  State<CategoryDesktopPage> createState() => _CategoryDesktopPageState();
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

  /// Clears the selected category to show an empty “Add Category” form on the right.
  void _clearSelectedCategory() {
    setState(() {
      _selectedCategory = null;
    });
  }

  /// Builds top app bar with title and user info
  Widget _buildTopBar() {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dashboard Title
          Text(
            loc!.translate('categories_title'),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin
    final loc = AppLocalizations.of(context);
    return Scaffold(
      // Consider embedding this page into a desktop layout with NavigationRail
      /*
      If your dashboard uses NavigationRail, integrate this page as a body or nested page.
      The NavigationRail manages navigation selection and actions. This page manages content.
      */
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
                loc!.translate('no_categories_found'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Row(
                  // LEFT PANEL — Category list with search
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          // Search bar
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: loc!.translate(
                                  'category_search_hint',
                                ),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon:
                                    _searchTerm.isNotEmpty
                                        ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed:
                                              () => _searchController.clear(),
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
                              onLongPress:
                                  (category) => confirmDeleteCategory(
                                    context,
                                    widget.userId,
                                    category,
                                  ),
                              selectedCategory: _selectedCategory,
                            ),
                          ),
                          // Clear selection button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: _clearSelectedCategory,
                              icon: const Icon(Icons.clear),
                              label: Text(
                                loc.translate('clear_selection_label'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Flexible(
                      flex: 3,
                      child: CategoryForm(
                        userId: widget.userId,
                        existingCategory: _selectedCategory,
                        closeOnSubmit: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
