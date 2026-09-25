import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/user_service.dart';

/// ENHANCEMENT 3: Settings Screen with Dark/Light Mode Toggle
/// This screen provides user settings, primarily for theme management.
/// Users can toggle between dark and light modes using a switch.
/// The selected theme is applied globally to the entire application.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: true,
      ),

      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: theme.brightness == Brightness.light
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Clear session and return to login',
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () async {
                    await UserService().logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// ENHANCEMENT 3: Dark/Light mode switch
              /// When enabled, ThemeProvider changes the application's
              /// ThemeMode. Because MaterialApp uses ThemeProvider,
              /// all screens using theme colors will update automatically.
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: theme.brightness == Brightness.light
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),

                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      themeProvider.isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: colorScheme.secondary,
                    ),
                  ),

                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  subtitle: Text(
                    themeProvider.isDark
                        ? 'Dark mode is enabled'
                        : 'Use light mode',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.60),
                      fontSize: 12,
                    ),
                  ),

                  trailing: Switch(
                    value: themeProvider.isDark,

                    /// This changes the GLOBAL application theme.
                    onChanged: (_) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}