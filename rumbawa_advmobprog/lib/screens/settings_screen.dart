import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

/// ENHANCEMENT 3: Settings Screen with Dark/Light Mode Toggle
/// This screen provides user settings, primarily for theme management.
/// Users can toggle between dark and light modes using a switch.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: true,
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            children: [
              /// ENHANCEMENT 3: Dark/Light mode switch
              /// This ListTile contains a Switch widget that controls the app theme.
              /// - When ON: Dark theme is applied
              /// - When OFF: Light theme is applied
              /// The switch is connected to [ThemeProvider.toggleTheme()] method
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
