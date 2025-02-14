import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LIGHT AND DARK MODE THEME FUNCTIONS USING PROVIDER
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }
// TOGGLING THEME
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme(_isDarkMode);
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
