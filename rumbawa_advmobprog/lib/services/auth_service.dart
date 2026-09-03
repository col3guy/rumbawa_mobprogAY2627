import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class AuthService {
  // ============================================================
  // LOGIN
  //
  // DummyJSON authentication endpoint:
  // POST /user/login
  //
  // This returns the logged-in user's information,
  // including the user's ID.
  // ============================================================
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$host/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);

      throw Exception(
        data['message'] ?? 'Login failed',
      );
    }
  }
}