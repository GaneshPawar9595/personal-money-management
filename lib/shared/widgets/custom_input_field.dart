import 'package:flutter/material.dart';

/// 📝 **CustomInputField**
///
/// This is a reusable input field widget that wraps Flutter's `TextFormField`.
/// It supports:
/// - Icons (prefix and optional suffix for password visibility)
/// - Hint text and label
/// - Validation
/// - Obscure text (for passwords)
/// - Custom styling and border colors
class CustomInputField extends StatelessWidget {
  /// Controller to read or update the text in the field
  final TextEditingController controller;

  /// Hint text displayed inside the field when empty
  final String hintText;

  /// Label displayed above the field
  final String label;

  /// Icon displayed at the start of the field
  final IconData icon;

  /// Keyboard type (text, email, phone, etc.)
  final TextInputType keyboardType;

  /// Whether to hide the text (e.g., for passwords)
  final bool obscureText;

  /// If true, adds a visibility toggle icon for password fields
  final bool isPassword;

  /// Validation function to check input and return an error message
  final String? Function(String?)? validator;

  /// Callback triggered when password visibility icon is tapped
  final VoidCallback? toggleObscure;

  /// Tracks the current password visibility state
  final bool? obscureState;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.validator,
    this.toggleObscure,
    this.obscureState,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText, // hides text if true
      keyboardType: keyboardType,
      validator: validator, // runs validation logic when form is submitted
      cursorColor: Colors.deepPurple,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        // Label above the field
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16),

        // Hint text inside the field
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),

        // Prefix icon (always visible)
        prefixIcon: Icon(icon, color: Colors.blueAccent),

        // Optional suffix icon for password visibility toggle
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureState! ? Icons.visibility_off : Icons.visibility,
            color: Colors.blueAccent,
          ),
          onPressed: toggleObscure,
        )
            : null,

        // Background fill color
        filled: true,
        fillColor: Colors.white,

        // Padding inside the field
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
