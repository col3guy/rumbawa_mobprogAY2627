import 'package:flutter/material.dart';

/// ENHANCEMENT 3: Theme Provider for Dark/Light Mode Support
/// This provider manages the application theme state using the provider pattern.
/// It allows users to toggle between light and dark themes across the entire app.
class ThemeProvider with ChangeNotifier {
  // ============================================================
  // NU BD EXCHANGE BRAND COLORS
  // ============================================================

  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);

  // ============================================================
  // DARK MODE COLORS
  // ============================================================

  static const Color darkBackground = Color(0xFF11103B);
  static const Color darkCard = Color(0xFF1A1953);

  // ============================================================
  // LIGHT MODE COLORS
  // ============================================================

  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightCard = Color(0xFFFFFFFF);

  bool _isDark = false;

  bool get isDark => _isDark;

  /// ENHANCEMENT 3: Light theme configuration
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,

      scaffoldBackgroundColor: lightBackground,

      primaryColor: navy,

      colorScheme: const ColorScheme.light(
        primary: navy,
        secondary: orange,
        surface: lightCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: navy,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      cardTheme: const CardThemeData(
        color: lightCard,
        elevation: 0,
      ),

      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: orange,
        unselectedItemColor: Color(0xFF777777),
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: orange,
        foregroundColor: Colors.white,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return orange;
            }

            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return lightOrange;
            }

            return Colors.grey.shade300;
          },
        ),
      ),

      useMaterial3: true,
    );
  }

  /// ENHANCEMENT 3: Dark theme configuration
  ///
  /// Dark mode keeps the original NU BD Exchange
  /// navy and orange branding. No purple colors are used.
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,

      scaffoldBackgroundColor: darkBackground,

      primaryColor: orange,

      colorScheme: const ColorScheme.dark(
        primary: orange,
        secondary: orange,
        surface: darkCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      cardTheme: const CardThemeData(
        color: darkCard,
        elevation: 0,
      ),

      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: orange,
        unselectedItemColor: Color(0xFFBDBDBD),
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: orange,
        foregroundColor: Colors.white,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return orange;
            }

            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return orange.withOpacity(0.35);
            }

            return Colors.grey.shade700;
          },
        ),
      ),

      useMaterial3: true,
    );
  }

  /// ENHANCEMENT 3: Toggle theme between light and dark.
  /// This changes the theme for the entire MaterialApp.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}