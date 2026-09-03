import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';

/// ============================================================
/// ENHANCEMENT 2:
/// Product Details Screen
///
/// Displays detailed information about the selected product.
/// ============================================================
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  // ============================================================
  // ENHANCEMENT 3:
  // User ID used when adding the product to the cart.
  // Currently using DummyJSON user ID 1.
  // ============================================================
  final int userId;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.userId,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  final CartService _cartService = CartService();

  bool isAdding = false;

  // ============================================================
  // ENHANCEMENT 3:
  // Add the selected product to the user's cart.
  //
  // Sends:
  // - userId
  // - productId
  // - quantity
  // ============================================================
  Future<void> _addToCart() async {
    if (isAdding) return;

    setState(() {
      isAdding = true;
    });

    try {
      await _cartService.addToCart(
        userId: widget.userId,
        productId: widget.product.id,
        quantity: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.product.title} added to cart!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add product to cart: $e',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isAdding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ==================================================
            // ENHANCEMENT 2:
            // Product Image
            // ==================================================
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12),
              child: Image.network(
                product.thumbnail,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    height: 280,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // ENHANCEMENT 2:
            // Product Title
            // ==================================================
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // ENHANCEMENT 2:
            // Product Price
            // ==================================================
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ENHANCEMENT 2:
            // Product Description
            // ==================================================
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // ENHANCEMENT 2:
            // Product Rating
            // ==================================================
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(width: 5),
                Text(
                  '${product.rating}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ENHANCEMENT 2:
            // Product Stock
            // ==================================================
            Text(
              'Stock: ${product.stock}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ENHANCEMENT 2:
            // Category
            // ==================================================
            Text(
              'Category: ${product.category}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // ENHANCEMENT 3:
            // Add to Cart Button
            //
            // Uses:
            // userId = 1
            // productId = selected product ID
            // quantity = 1
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed:
                    isAdding ? null : _addToCart,

                icon: isAdding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_cart,
                      ),

                label: Text(
                  isAdding
                      ? 'Adding...'
                      : 'Add to Cart',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}