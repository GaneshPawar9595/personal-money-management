import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/category_entity.dart';
import '../provider/category_provider.dart';
import 'package:provider/provider.dart';

typedef OnCategorySelected = void Function(CategoryEntity category);

class CategorySelector extends StatefulWidget {
  final CategoryEntity? selectedCategory;
  final OnCategorySelected onCategorySelected;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<CategoryEntity> filteredCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final categories = context.read<CategoryProvider>().categories;
    filteredCategories = categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategoryModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final allCategories = context.read<CategoryProvider>().categories;

            void _onSearchChanged(String query) {
              setModalState(() {
                filteredCategories = query.isEmpty
                    ? allCategories
                    : allCategories
                    .where((cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Search Category",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: filteredCategories.isEmpty
                        ? const Center(child: Text('No categories found'))
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final cat = filteredCategories[index];
                        return ListTile(
                          leading: Icon(cat.iconData, color: cat.color),
                          title: Text(cat.name, style: GoogleFonts.poppins(fontSize: 16)),
                          onTap: () {
                            widget.onCategorySelected(cat);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedCategory;
    return GestureDetector(
      onTap: _openCategoryModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (selected != null)
                  Icon(selected.iconData, color: selected.color)
                else
                  const Icon(Icons.category, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  selected?.name ?? "Select Category",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
