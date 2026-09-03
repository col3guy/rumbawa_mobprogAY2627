import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class UserService {
  // ============================================================
  // Get all DummyJSON users
  // ============================================================
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(
      Uri.parse('$host/users?limit=0'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final List users = data['users'] ?? [];

      return users
          .map(
            (user) => Map<String, dynamic>.from(user),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load users: ${response.statusCode}',
      );
    }
  }

  // ============================================================
  // Get one DummyJSON user by ID
  // ============================================================
  Future<Map<String, dynamic>> getUserById(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse('$host/users/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load user: ${response.statusCode}',
      );
    }
  }
}