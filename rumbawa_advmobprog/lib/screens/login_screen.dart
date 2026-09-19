import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool isLoading = false;
  bool obscurePassword = true;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FC);
  static const Color textGray = Color(0xFF777777);

  // ============================================================
  // ENHANCEMENT 2:
  // Custom Sign-In UI using UserService and authentication logic.
  // AuthService handles the actual authentication.
  // UserService saves the authenticated user's information.
  // ============================================================

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter your username and password.',
          ),
          backgroundColor: orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Existing authentication logic.
      final user = await _authService.login(
        username: username,
        password: password,
      );

      // Save the authenticated user for persistent authentication.
      await _userService.saveUserData(user);

      if (!mounted) return;

      final int userId = user['id'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // CUSTOM INPUT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 15,
            color: navy,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9A9A9A),
              fontSize: 14,
            ),

            // Orange icon
            prefixIcon: Icon(
              icon,
              color: orange,
              size: 21,
            ),

            suffixIcon: suffixIcon,

            filled: true,
            fillColor: const Color(0xFFF9F9FC),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: navy.withOpacity(0.12),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: orange,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DECORATIVE ORANGE CIRCLE
  // ============================================================

  Widget _circle({
    required double size,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: orange.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            children: [

              // ==================================================
              // NAVY HEADER
              // ==================================================

              Container(
                width: double.infinity,
                height: size.height * 0.34,

                decoration: const BoxDecoration(
                  color: navy,

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                ),

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [

                    // Orange decoration - top right
                    Positioned(
                      top: -55,
                      right: -40,
                      child: _circle(
                        size: 170,
                        opacity: 0.20,
                      ),
                    ),

                    // Orange decoration - bottom left
                    Positioned(
                      bottom: -30,
                      left: -55,
                      child: _circle(
                        size: 145,
                        opacity: 0.15,
                      ),
                    ),

                    // Small orange circle
                    Positioned(
                      top: 45,
                      left: 35,
                      child: _circle(
                        size: 18,
                        opacity: 0.9,
                      ),
                    ),

                    // Small orange circle
                    Positioned(
                      bottom: 45,
                      right: 35,
                      child: _circle(
                        size: 12,
                        opacity: 0.8,
                      ),
                    ),

                    // Header content
                    Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          // ==================================================
                          // LOGO
                          // ==================================================

                          Container(
                            width: 90,
                            height: 90,
                            padding: const EdgeInsets.all(13),

                            decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.circular(25),

                              border: Border.all(
                                color: orange,
                                width: 4,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.20),
                                  blurRadius: 20,
                                  offset:
                                      const Offset(0, 9),
                                ),
                              ],
                            ),

                            child: Image.asset(
                              'assets/images/nubdexchange_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // ==================================================
                          // TITLE
                          // ==================================================

                          const Text(
                            'NU BD EXCHANGE',
                            style: TextStyle(
                              color: white,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.3,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Orange line
                          Container(
                            width: 45,
                            height: 4,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'CAMPUS MARKETPLACE',
                            style: TextStyle(
                              color:
                                  white.withOpacity(0.80),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // LOGIN CARD
              // ==================================================

              Transform.translate(
                offset: const Offset(0, -28),

                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  padding: const EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    26,
                  ),

                  decoration: BoxDecoration(
                    color: white,
                    borderRadius:
                        BorderRadius.circular(28),

                    border: Border.all(
                      color: navy.withOpacity(0.08),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            navy.withOpacity(0.10),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ==================================================
                      // WELCOME
                      // ==================================================

                      Row(
                        children: [

                          Container(
                            width: 6,
                            height: 42,

                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight:
                                      FontWeight.w900,
                                  color: navy,
                                ),
                              ),

                              SizedBox(height: 3),

                              Text(
                                'Sign in to your account',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ==================================================
                      // USERNAME
                      // ==================================================

                      _buildTextField(
                        controller:
                            usernameController,
                        label: 'Username',
                        hint: 'Enter your username',
                        icon:
                            Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 21),

                      // ==================================================
                      // PASSWORD
                      // ==================================================

                      _buildTextField(
                        controller:
                            passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        icon:
                            Icons.lock_outline_rounded,
                        obscureText:
                            obscurePassword,

                        suffixIcon:
                            IconButton(
                          splashRadius: 22,

                          icon: Icon(
                            obscurePassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons
                                    .visibility_outlined,

                            color: navy,
                          ),

                          onPressed: () {
                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // SIGN IN BUTTON
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        height: 56,

                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : _login,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: orange,

                            disabledBackgroundColor:
                                const Color(0xFFFFC7A5),

                            foregroundColor: white,

                            elevation: 5,

                            shadowColor:
                                orange.withOpacity(0.35),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),

                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,

                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      white,
                                    ),
                                  ),
                                )

                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,

                                  children: const [

                                    Text(
                                      'SIGN IN',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),

                                    SizedBox(width: 10),

                                    Icon(
                                      Icons
                                          .arrow_forward_rounded,
                                      size: 21,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // SECURITY BOX
                      // ==================================================

                      Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(13),

                        decoration: BoxDecoration(
                          color: lightOrange,

                          borderRadius:
                              BorderRadius.circular(14),

                          border: Border.all(
                            color:
                                orange.withOpacity(0.25),
                          ),
                        ),

                        child: Row(
                          children: [

                            Container(
                              width: 36,
                              height: 36,

                              decoration:
                                  const BoxDecoration(
                                color: orange,
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons
                                    .verified_user_outlined,
                                color: white,
                                size: 19,
                              ),
                            ),

                            const SizedBox(width: 11),

                            const Expanded(
                              child: Text(
                                'Your account information is securely stored.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: navy,
                                  height: 1.4,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // FOOTER
              // ==================================================

              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 25,
                ),

                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: orange,
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          'SHOP',
                          style: TextStyle(
                            color: navy,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: orange,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: orange,
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          'CONNECT',
                          style: TextStyle(
                            color: navy,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: orange,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.sync_alt_rounded,
                          size: 14,
                          color: orange,
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          'EXCHANGE',
                          style: TextStyle(
                            color: navy,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'NU BD Exchange',
                      style: TextStyle(
                        fontSize: 11,
                        color: textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}