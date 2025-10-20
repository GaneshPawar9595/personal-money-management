import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String, String> _localizedStrings;

  // Dynamically load all JSON files from the assets/lang directory
  Future<bool> load() async {
    // Load the appropriate locale file
    final String jsonString =
    await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Update the _localizedStrings map with all loaded data
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? '** $key not found';
  }

  // Function to load all language files from assets/lang
  static Future<Map<String, Map<String, String>>> loadAll() async {
    final Map<String, Map<String, String>> allLocales = {};

    final List<String> supportedLanguages = ['en', 'hi'];  // Add supported languages here

    for (var lang in supportedLanguages) {
      final String jsonString =
      await rootBundle.loadString('assets/lang/$lang.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      allLocales[lang] = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }

    return allLocales;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
