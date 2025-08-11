import 'package:flutter/material.dart';

enum AppThemeMode {
  light('Light', Icons.light_mode),
  dark('Dark', Icons.dark_mode),
  system('System', Icons.brightness_auto);

  const AppThemeMode(this.name, this.icon);

  final String name;
  final IconData icon;
}

class ThemeService extends ChangeNotifier {
  static ThemeService? _instance;
  static ThemeService get instance => _instance ??= ThemeService._();
  ThemeService._();

  AppThemeMode _currentTheme = AppThemeMode.system;

  AppThemeMode get currentTheme => _currentTheme;
  String get themeName => _currentTheme.name;
  IconData get themeIcon => _currentTheme.icon;

  void init() {
    // Simple in-memory storage for now
    _currentTheme = AppThemeMode.system;
  }

  void setTheme(AppThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  // Get all available themes
  List<AppThemeMode> get availableThemes => AppThemeMode.values;

  // Get the actual Flutter ThemeMode for MaterialApp
  ThemeMode get flutterThemeMode {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
