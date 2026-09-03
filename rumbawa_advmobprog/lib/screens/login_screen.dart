import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;

  // ============================================================
  // LOGIN
  //
  // Authenticates the user using DummyJSON.
  // The returned user ID is passed to HomeScreen.
  // ============================================================
  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your username and password.'),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // Authenticate using DummyJSON
      // ========================================================
      final user = await _authService.login(
        username: username,
        password: password,
      );

      // ========================================================
      // DEBUG:
      // Show the returned user information in the terminal.
      // ========================================================
      print('========================================');
      print('LOGIN SUCCESSFUL');
      print('USER DATA: $user');
      print('USER ID: ${user['id']}');
      print('USERNAME: ${user['username']}');
      print('NAME: ${user['firstName']} ${user['lastName']}');
      print('EMAIL: ${user['email']}');
      print('========================================');

      if (!mounted) return;

      // ========================================================
      // Get the ID of the logged-in user.
      // ========================================================
      final int userId = user['id'];

      // ========================================================
      // Open HomeScreen and pass the logged-in user's ID.
      // ========================================================
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userId: userId)),
      );
    } catch (e) {
      if (!mounted) return;

      print('========================================');
      print('LOGIN ERROR: $e');
      print('========================================');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 80),

                const SizedBox(height: 20),

                const Text(
                  'Welcome to Commerce App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Login using your DummyJSON account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // USERNAME
                // ==================================================
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // PASSWORD
                // ==================================================
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // LOGIN BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
