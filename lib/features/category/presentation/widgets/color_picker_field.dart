import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../config/localization/app_localizations.dart'; // Adjust path if needed

class ColorPickerField extends StatefulWidget {
  final String initialHexColor;
  final ValueChanged<String> onColorChanged;
  final String? label;
  final String? errorText;

  const ColorPickerField({
    super.key,
    this.initialHexColor = '#2196F3',
    required this.onColorChanged,
    this.label,
    this.errorText,
  });

  @override
  State<ColorPickerField> createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _hexToColor(widget.initialHexColor);
  }

  @override
  void didUpdateWidget(covariant ColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialHexColor != oldWidget.initialHexColor) {
      setState(() {
        _selectedColor = _hexToColor(widget.initialHexColor);
      });
    }
  }

  Color _hexToColor(String hexColor) {
    var hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  String _colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  void _showColorPicker() {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) {
        Color tempSelected = _selectedColor;
        return AlertDialog(
          title: Text(loc!.translate('color_picker_title')),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => tempSelected = color,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.translate('cancel_button')),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedColor = tempSelected;
                });
                widget.onColorChanged(_colorToHex(_selectedColor));
                Navigator.of(context).pop();
              },
              child: Text(loc.translate('select_button')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return GestureDetector(
      onTap: _showColorPicker,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label ?? loc!.translate('color_code_label'),
          errorText: widget.errorText,
          border: const OutlineInputBorder(),
          suffixIcon: Icon(Icons.color_lens, color: _selectedColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black26),
              ),
            ),
            const SizedBox(width: 8),
            Text(_colorToHex(_selectedColor)),
          ],
        ),
      ),
    );
  }
}
