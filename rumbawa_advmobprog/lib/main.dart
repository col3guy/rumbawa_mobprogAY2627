import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point of the app.
// Wraps the entire app in a ChangeNotifierProvider so that ThemeModel
// (our app state) is accessible from any widget in the tree, across both screens.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ), // ChangeNotifierProvider
  );
}

// Root widget of the application.
// Reads the current theme state from ThemeModel and applies it
// to the MaterialApp, so the theme is consistent across all screens.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      theme: themeModel.isDark ? ThemeData.dark() : ThemeData.light(),
      home: const CounterPage(),
    ); // MaterialApp
  }
}

// --- App State (shared across screens) ---
// Holds data (isDark) that needs to be accessed and updated from
// multiple screens. Uses ChangeNotifier so it can notify listening
// widgets to rebuild whenever the data changes.
class ThemeModel with ChangeNotifier {
  // Tracks whether dark mode is currently on.
  bool _isDark = false;

  // Public getter so other widgets can read the current theme state.
  bool get isDark => _isDark;

  // Flips the theme between light and dark, then notifies listeners
  // so any widget using ThemeModel rebuilds with the new theme.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

// --- Screen 1: Counter (Ephemeral State) ---
// Displays a counter that only this screen cares about,
// plus a button to navigate to the Theme Settings screen.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

// Ephemeral state class.
// Holds data (_counter) local to this screen only.
// This state is lost once CounterPage is removed from the widget tree.
class _CounterPageState extends State<CounterPage> {
  // Tracks how many times the button has been pressed.
  int _counter = 0;

  // Increments the counter and calls setState() so Flutter rebuilds
  // this widget with the new counter value.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Navigates to the ThemePage (Screen 2) when the button is pressed.
  void _goToThemePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThemePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter (Ephemeral State)'),
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            // Displays the ephemeral state value (_counter).
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ), // Text
            const SizedBox(height: 24),
            // Button that navigates to the Theme Settings screen.
            ElevatedButton(
              onPressed: _goToThemePage,
              child: const Text('Go to Theme Settings'),
            ), // ElevatedButton
          ], // <Widget>[]
        ), // Column
      ), // Center
      // Button that triggers the ephemeral state update.
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // FloatingActionButton
    ); // Scaffold
  }
}

// --- Screen 2: Theme Toggle (App State) ---
// Lets the user toggle the app-wide theme using a switch.
// Since ThemeModel is app state, this change reflects across all screens,
// including CounterPage.
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to ThemeModel so the Switch always reflects the current theme.
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings (App State)'),
        actions: [
          // Switch reads/writes app state (ThemeModel), not local widget state.
          Switch(
            value: themeModel.isDark,
            onChanged: (_) => themeModel.toggleTheme(),
          ), // Switch
        ],
      ), // AppBar
      body: Center(
        child: const Text('Toggle the theme using the switch in the app bar.'),
      ), // Center
    ); // Scaffold
  }
}