import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🌙 **ThemeProvider**
///
/// This class manages the app's **theme mode** (Light or Dark).
/// It allows switching themes dynamically and **remembers the user's choice**
/// using SharedPreferences.
class ThemeProvider with ChangeNotifier {
  /// The current theme of the app (default: Light)
  ThemeMode _themeMode = ThemeMode.light;

  /// Public getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Constructor: loads the saved theme from SharedPreferences when the app starts
  ThemeProvider() {
    _loadTheme();
  }

  /// 🔄 Toggle between Light and Dark theme
  ///
  /// - Updates `_themeMode` variable
  /// - Notifies listeners so widgets using this provider rebuild
  /// - Saves the choice persistently with SharedPreferences
  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Triggers rebuild for MaterialApp or other widgets

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", _themeMode == ThemeMode.dark); // Save choice
  }

  /// 🔄 Load the saved theme from SharedPreferences
  ///
  /// - Defaults to light theme if nothing is saved
  /// - Updates `_themeMode` and notifies listeners
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDark") ?? false; // Default to Light
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
