import 'package:flutter/material.dart';

import '../services/user_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();

    // ============================================================
    // ENHANCEMENT 1:
    // Custom splash screen with persistent authentication.
    // ============================================================
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    // ============================================================
    // ENHANCEMENT 1:
    // Check whether the user has an existing saved login session.
    // ============================================================
    final loggedIn = await _userService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      try {
        // Retrieve the saved user.
        final user = await _userService.getUser();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userId: user.id,
            ),
          ),
        );
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ==========================================================
        // CUSTOM SPLASH BACKGROUND
        // ==========================================================
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF11103F),
              Color(0xFF1A1953),
              Color(0xFF302E78),
            ],
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -90,
                right: -70,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              // Decorative circle
              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==================================================
                    // CUSTOM LOGO CONTAINER
                    // ==================================================
                    Container(
                      width: 210,
                      height: 210,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/nubdexchange_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'NU BD EXCHANGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Your Campus Marketplace',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // ==================================================
                    // CUSTOM LOADING INDICATOR
                    // ==================================================
                    Container(
                      width: 55,
                      height: 55,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DE22),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          Color(0xFF1A1953),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // BOTTOM BRANDING
              // ==================================================
              const Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                child: Text(
                  'SHOP • CONNECT • EXCHANGE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}