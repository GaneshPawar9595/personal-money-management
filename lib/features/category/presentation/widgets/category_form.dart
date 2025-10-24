import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/category_entity.dart';
import '../provider/category_provider.dart';
import '../../../../core/utils/validation.dart';
import 'package:money_management/shared/widgets/custom_input_field.dart';
import 'color_picker_field.dart';

/// Form for adding or editing a category.
///
/// Features:
/// - Select category icon from Material or Cupertino icons.
/// - Pick color visually using color picker.
/// - Validate form fields and provide feedback.
/// - Works seamlessly for both "Add" and "Edit" actions on desktop, tablet, or mobile layouts.
class CategoryForm extends StatefulWidget {
  final String userId;
  final CategoryEntity? existingCategory;
  final bool? closeOnSubmit; // Determines whether to close form after submission.

  const CategoryForm({
    super.key,
    required this.userId,
    this.existingCategory,
    this.closeOnSubmit,
  });

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _colorCodeController;
  late TextEditingController _messageController;

  late IconData _selectedIcon;
  late String _selectedIconFontFamily;
  String? _selectedIconFontPackage;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  @override
  void didUpdateWidget(covariant CategoryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.existingCategory != widget.existingCategory) {
      _initializeFormFields();
    }
  }

  /// Initializes controllers and icon selection, depending on whether editing or adding.
  void _initializeFormFields() {
    _nameController = TextEditingController(text: widget.existingCategory?.name ?? '');
    _colorCodeController = TextEditingController(
      text: widget.existingCategory?.colorHex ?? 'FF000000',
    );
    _messageController = TextEditingController(
      text: widget.existingCategory?.message ?? '',
    );

    final existing = widget.existingCategory;
    if (existing != null) {
      _selectedIcon = existing.iconData;
      _selectedIconFontFamily = existing.iconFontFamily;
      _selectedIconFontPackage = existing.iconFontPackage;
    } else {
      _selectedIcon = Icons.category;
      _selectedIconFontFamily = 'MaterialIcons';
      _selectedIconFontPackage = null;
    }
  }

  /// Launches the icon picker for the user to select a category icon.
  Future<void> _pickIcon() async {
    final picked = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material, IconPack.cupertino], // Support both icons
      ),
    );

    setState(() {
      if (picked?.data != null) {
        _selectedIcon = picked!.data;
        _selectedIconFontFamily = picked.pack == IconPack.material
            ? 'MaterialIcons'
            : 'CupertinoIcons';
        _selectedIconFontPackage = null;
      } else {
        // Default fallback icon if user cancels selection
        _selectedIcon = Icons.category;
        _selectedIconFontFamily = 'MaterialIcons';
        _selectedIconFontPackage = null;
      }
    });
  }

  /// Displays an error snackbar message in red background for critical information.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorCodeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Submits category data to the provider. Handles both Add and Edit workflows.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final provider = Provider.of<CategoryProvider>(context, listen: false);

    final category = CategoryEntity(
      id: widget.existingCategory?.id ?? UniqueKey().toString(),
      userId: widget.userId,
      name: _nameController.text.trim(),
      colorHex: _colorCodeController.text.trim(),
      message: _messageController.text.trim(),
      iconCodePoint: _selectedIcon.codePoint,
      iconFontFamily: _selectedIconFontFamily,
      iconFontPackage: _selectedIconFontPackage,
    );

    try {
      // Add or update based on whether existing category is provided
      if (widget.existingCategory == null) {
        await provider.addCategory(category);
      } else {
        await provider.updateCategory(category);
      }

      // Provide feedback based on result
      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingCategory == null
                ? 'Category added successfully'
                : 'Category updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.closeOnSubmit ?? true) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
        }
      } else {
        _showError(provider.error!);
      }
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  /// Resets the form fields to default or previously loaded category values.
  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _initializeFormFields();
    });
  }

  /// Converts a hex string (e.g. 'FF00FF00') to a usable Color object.
  Color _hexToColor(String hexColor) {
    var hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // adds alpha if missing
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: 475,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.existingCategory == null ? 'Add Category' : 'Edit Category',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            // Icon selection section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedIcon,
                  size: 48,
                  color: _hexToColor(_colorCodeController.text),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _pickIcon,
                  icon: const Icon(Icons.edit),
                  label: const Text('Select Icon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Category name input field
            CustomInputField(
              controller: _nameController,
              hintText: 'Category Name',
              label: 'Category Name',
              icon: Icons.category,
              validator: (value) => Validators.validateCategoryName(
                value,
                "Please enter a category name",
              ),
            ),

            const SizedBox(height: 20),

            // Color picker field to choose display color
            ColorPickerField(
              initialHexColor: _colorCodeController.text,
              label: 'Color Code',
              errorText: _colorCodeController.text.isEmpty
                  ? 'Please select a color'
                  : null,
              onColorChanged: (hex) {
                setState(() => _colorCodeController.text = hex);
              },
            ),

            const SizedBox(height: 20),

            // Optional message field
            CustomInputField(
              controller: _messageController,
              hintText: 'Message',
              label: 'Message',
              icon: Icons.message,
              validator: (value) => Validators.validateCategoryName(
                value,
                "Please enter a message",
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 20),

            // Action buttons: Submit and Clear
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Submit'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _clearForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
