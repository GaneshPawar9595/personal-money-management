import 'package:flutter/material.dart';

/// 🟦 **CustomElevatedButton**
///
/// This is a reusable button widget based on Flutter's ElevatedButton.
/// It allows you to customize:
/// - Button text
/// - Background color
/// - Rounded corners
/// - Font size
/// - OnPressed callback
class CustomElevatedButton extends StatelessWidget {
  /// Callback triggered when the button is pressed
  final VoidCallback? onPressed;

  /// Text displayed on the button
  final String text;

  /// Background color of the button (default: blue accent)
  final Color backgroundColor;

  /// Rounded corner radius of the button (default: 12)
  final double borderRadius;

  /// Font size of the button text (default: 18)
  final double fontSize;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.blueAccent,
    this.borderRadius = 12,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Disabled if null
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15), // Space inside button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        backgroundColor: backgroundColor, // Button color
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,         // Dynamic font size
          color: Colors.white,        // White text for contrast
          fontWeight: FontWeight.bold, // Bold text
        ),
      ),
    );
  }
}
