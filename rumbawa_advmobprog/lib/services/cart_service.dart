import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';

class CartService {
  // ============================================================
  // ENHANCEMENT 3:
  // Get only the cart belonging to a specific user.
  //
  // Uses the DummyJSON endpoint:
  // GET /carts/user/{userId}
  //
  // Example:
  // GET /carts/user/1
  // ============================================================
  Future<Cart?> getCartByUserId(int userId) async {
    final response = await http.get(
      Uri.parse(
        '$host/carts/user/$userId',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final List cartsJson =
          data['carts'] ?? [];

      // If the user has no cart.
      if (cartsJson.isEmpty) {
        return null;
      }

      // Render only the first cart belonging
      // to this user.
      return Cart.fromJson(
        cartsJson.first,
      );
    } else {
      throw Exception(
        'Failed to load user cart: ${response.statusCode}',
      );
    }
  }

  // ============================================================
  // ENHANCEMENT 3:
  // Add a product to the user's cart.
  //
  // Passes:
  // - userId
  // - productId
  // - quantity
  //
  // Uses the DummyJSON endpoint:
  // POST /carts/add
  // ============================================================
  Future<Cart> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse(
        '$host/carts/add',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'products': [
          {
            'id': productId,
            'quantity': quantity,
          },
        ],
      }),
    );

    // DummyJSON may return 200 or 201
    // when the request is successful.
    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      return Cart.fromJson(data);
    } else {
      throw Exception(
        'Failed to add product to cart: '
        '${response.statusCode}',
      );
    }
  }
}