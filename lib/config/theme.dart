import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ThemeConfig {
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
