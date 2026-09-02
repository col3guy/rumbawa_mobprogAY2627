import 'package:flutter/material.dart';

/// ENHANCEMENT 3: Theme Provider for Dark/Light Mode Support
/// This provider manages the application theme state using the provider pattern.
/// It allows users to toggle between light and dark themes across the entire app.
class ThemeProvider with ChangeNotifier {
  /// Private variable to track if dark mode is currently enabled
  bool _isDark = false;

  /// Public getter to access the current dark mode state
  bool get isDark => _isDark;

  /// ENHANCEMENT 3: Light theme configuration
  /// Returns the light theme data for the application
  ThemeData get lightTheme {
    return ThemeData.light();
  }

  /// ENHANCEMENT 3: Dark theme configuration
  /// Returns the dark theme data for the application
  ThemeData get darkTheme {
    return ThemeData.dark();
  }

  /// ENHANCEMENT 3: Toggle theme between light and dark
  /// Switches the theme state and notifies all listening widgets
  /// This is called when the user interacts with the dark mode switch in settings
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners(); // Notify all listeners to rebuild with new theme
  }
}
