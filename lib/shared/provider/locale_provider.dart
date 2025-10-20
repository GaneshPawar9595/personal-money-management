import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🌐 **LocaleProvider**
///
/// This class manages the **current language (locale)** of the app.
/// It allows changing the language and **remembers the choice** using SharedPreferences.
class LocaleProvider with ChangeNotifier {
  /// The current locale of the app (default: English)
  Locale _locale = const Locale('en');

  /// Public getter to access the current locale
  Locale get locale => _locale;

  /// Constructor: loads the saved locale from SharedPreferences when the app starts
  LocaleProvider() {
    _loadLocale();
  }

  /// 🌟 Change the app language
  ///
  /// - Updates the `_locale` variable
  /// - Notifies all listeners (widgets that depend on locale will rebuild)
  /// - Saves the new locale persistently using SharedPreferences
  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners(); // Rebuilds widgets using this provider

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", locale.languageCode); // Save choice
  }

  /// 🔄 Load the saved locale from SharedPreferences
  ///
  /// - If nothing is saved, defaults to English ('en')
  /// - Updates `_locale` and notifies listeners
  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString("locale") ?? 'en'; // Default to English
    _locale = Locale(langCode);
    notifyListeners();
  }
}
