import 'package:flutter/material.dart';

import '../services/user_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController =
      TextEditingController();

  final _lastNameController =
      TextEditingController();

  final _ageController =
      TextEditingController();

  final _contactController =
      TextEditingController();

  final _usernameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final UserService _userService =
      UserService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _validateEmail(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Email is required.';
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firstName =
          _firstNameController.text.trim();

      final lastName =
          _lastNameController.text.trim();

      final age =
          _ageController.text.trim();

      final contactNo =
          _contactController.text.trim();

      final username =
          _usernameController.text.trim();

      final email =
          _emailController.text.trim();

      final password =
          _passwordController.text;

      // Create Firebase Authentication account
      final credential =
          await _userService.createAccount(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        username: username,
        age: age,
        contactNo: contactNo,
      );

      final firebaseUid =
          credential.user?.uid ?? '';

      if (firebaseUid.isEmpty) {
        throw Exception(
          'Unable to get Firebase user ID.',
        );
      }

      // Save user locally
      await _userService.saveUserData({
        'id': 0,
        'firebaseUid': firebaseUid,
        'uid': firebaseUid,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': '',
        'image': '',
        'accessToken': firebaseUid,
        'refreshToken': '',
        'token': firebaseUid,
        'age': age,
        'contactNo': contactNo,
        'loginType': 'firebase',
      });

      // Save user to Firestore
      await _userService.saveUserToFirestore(
        uid: firebaseUid,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully. Please sign in.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(
          () => _isLoading = false,
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A1953);
    const orange = Color(0xFFFF8A3D);
    const white = Color(0xFFFFFFFF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: navy,
        foregroundColor: white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create your new account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller:
                            _firstNameController,
                        label: 'First Name',
                        prefixIcon:
                            Icons.person,
                        validator: (value) =>
                            value == null ||
                                    value
                                        .trim()
                                        .isEmpty
                                ? 'First name is required.'
                                : null,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildInput(
                        controller:
                            _lastNameController,
                        label: 'Last Name',
                        prefixIcon:
                            Icons.person,
                        validator: (value) =>
                            value == null ||
                                    value
                                        .trim()
                                        .isEmpty
                                ? 'Last name is required.'
                                : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller:
                            _ageController,
                        label: 'Age',
                        prefixIcon:
                            Icons.calendar_today,
                        keyboardType:
                            TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Age is required.';
                          }

                          final age =
                              int.tryParse(value);

                          if (age == null ||
                              age <= 0) {
                            return 'Enter a valid age.';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildInput(
                        controller:
                            _contactController,
                        label: 'Contact No.',
                        prefixIcon:
                            Icons.phone,
                        keyboardType:
                            TextInputType.phone,
                        validator: (value) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Contact number is required.';
                          }

                          final digits =
                              value.replaceAll(
                            RegExp(r'\D'),
                            '',
                          );

                          if (digits.length < 8) {
                            return 'Enter a valid contact number.';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller:
                      _usernameController,
                  label: 'Username',
                  prefixIcon:
                      Icons.account_circle,
                  validator: (value) =>
                      value == null ||
                              value
                                  .trim()
                                  .isEmpty
                          ? 'Username is required.'
                          : null,
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller:
                      _emailController,
                  label: 'Email Address',
                  prefixIcon: Icons.email,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller:
                      _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText:
                      _obscurePassword,
                  validator:
                      _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _submitSignup,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: white,
                          )
                        : const Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Sign in',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType =
        TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    );
  }
}