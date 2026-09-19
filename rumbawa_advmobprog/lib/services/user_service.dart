import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  Map<String, dynamic> data = {};

  // ============================================================
  // ENHANCEMENT 2:
  // Login using the UserService.
  //
  // NOTE:
  // The current LoginScreen still uses AuthService for the
  // actual authentication because that is the working
  // authentication logic in this project.
  // UserService is responsible for saving and retrieving
  // the authenticated user's data.
  // ============================================================
  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final response = await post(
      Uri.parse('$host/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      await saveUserData(data);

      return data;
    } else {
      throw Exception(response.body);
    }
  }

  // ============================================================
  // ENHANCEMENT 2:
  // Save the authenticated user's information to
  // SharedPreferences so the login session can persist.
  // ============================================================
  Future<void> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final user = User.fromJson(userData);

    await prefs.setInt('id', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setString('gender', user.gender);
    await prefs.setString('image', user.image);
    await prefs.setString('accessToken', user.accessToken);
    await prefs.setString('refreshToken', user.refreshToken);

    // Save token using either "token" or "accessToken".
    if (userData.containsKey('token')) {
      await prefs.setString(
        'token',
        userData['token'] ?? '',
      );
    } else if (user.accessToken.isNotEmpty) {
      await prefs.setString(
        'token',
        user.accessToken,
      );
    }
  }

  // ============================================================
  // ENHANCEMENT 1:
  // Retrieve the saved user information from
  // SharedPreferences.
  // ============================================================
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'id': prefs.getInt('id') ?? 0,
      'username': prefs.getString('username') ?? '',
      'email': prefs.getString('email') ?? '',
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'image': prefs.getString('image') ?? '',
      'accessToken': prefs.getString('accessToken') ?? '',
      'refreshToken': prefs.getString('refreshToken') ?? '',
      'token':
          prefs.getString('token') ??
          prefs.getString('accessToken') ??
          '',
    };
  }

  // ============================================================
  // ENHANCEMENT 3:
  // Convert the saved user data into our custom User model.
  // ============================================================
  Future<User> getUser() async {
    final userData = await getUserData();

    return User.fromJson(userData);
  }

  // ============================================================
  // ENHANCEMENT 1:
  // Check if the user has a saved authentication token.
  // This is used by the splash screen for persistent login.
  // ============================================================
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final token =
        prefs.getString('accessToken') ??
        prefs.getString('token');

    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // Get a user from the backend using the user's ID.
  // ============================================================
  Future<Map<String, dynamic>> getUserById(
    int userId,
  ) async {
    final response = await get(
      Uri.parse('$host/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // ============================================================
  // Logout:
  // Clear the persistent authentication data.
  // ============================================================
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.clear();
    } catch (e) {
      throw Exception(
        'Failed to log out: $e',
      );
    }
  }
}