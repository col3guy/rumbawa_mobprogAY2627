import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

import 'product_details_screen.dart';

class CartScreen extends StatefulWidget {
  final int userId;

  const CartScreen({
    super.key,
    required this.userId,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  Cart? cart;
  bool isLoading = true;
  bool isOpeningProduct = false;

  // ============================================================
  // ENHANCEMENT 1:
  // Stores the current quantity of each product.
  // ============================================================
  final Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // ============================================================
  // ENHANCEMENT 3:
  // Load the cart of one specific user.
  // ============================================================
  Future<void> _loadCart() async {
    try {
      final result =
          await _cartService.getCartByUserId(widget.userId);

      if (!mounted) return;

      setState(() {
        cart = result;
        isLoading = false;

        // Store the quantity of every cart product.
        quantities.clear();

        if (result != null) {
          for (final product in result.products) {
            quantities[product.id] = product.quantity;
          }
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load cart.'),
        ),
      );
    }
  }

  // ============================================================
  // ENHANCEMENT 1:
  // Increase product quantity.
  // ============================================================
  void _increaseQuantity(CartProduct product) {
    setState(() {
      final currentQuantity =
          quantities[product.id] ?? product.quantity;

      quantities[product.id] = currentQuantity + 1;
    });
  }

  // ============================================================
  // ENHANCEMENT 1:
  // Decrease product quantity.
  //
  // Quantity will not go below 1.
  // ============================================================
  void _decreaseQuantity(CartProduct product) {
    final currentQuantity =
        quantities[product.id] ?? product.quantity;

    if (currentQuantity <= 1) {
      return;
    }

    setState(() {
      quantities[product.id] = currentQuantity - 1;
    });
  }

  // ============================================================
  // ENHANCEMENT 1:
  // Calculate the subtotal using the updated quantities.
  // ============================================================
  double _getSubtotal() {
    if (cart == null) {
      return 0;
    }

    double subtotal = 0;

    for (final product in cart!.products) {
      final quantity =
          quantities[product.id] ?? product.quantity;

      subtotal += product.price * quantity;
    }

    return subtotal;
  }

  // ============================================================
  // ENHANCEMENT 2:
  // Open Product Details when a cart product is clicked.
  // ============================================================
  Future<void> _openProductDetails(
    CartProduct cartProduct,
  ) async {
    if (isOpeningProduct) return;

    setState(() {
      isOpeningProduct = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$host/products/${cartProduct.id}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final Product product =
            Product.fromJson(data);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
              userId: widget.userId,
            ),
          ),
        );
      } else {
        throw Exception(
          'Failed to load product',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to open product details.',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isOpeningProduct = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cart == null ||
                  cart!.products.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : Column(
                  children: [
                    // ==================================================
                    // PRODUCT LIST
                    // ==================================================
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadCart,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount:
                              cart!.products.length,
                          itemBuilder:
                              (context, index) {
                            final product =
                                cart!.products[index];

                            final quantity =
                                quantities[product.id] ??
                                    product.quantity;

                            final itemTotal =
                                product.price *
                                    quantity;

                            return Card(
                              margin:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              elevation: 2,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),

                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                  10,
                                ),

                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                  children: [
                                    // ==================================================
                                    // PRODUCT IMAGE
                                    // ==================================================
                                    GestureDetector(
                                      onTap: () {
                                        _openProductDetails(
                                          product,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          8,
                                        ),
                                        child:
                                            Image.network(
                                          product.thumbnail,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,

                                          loadingBuilder:
                                              (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress ==
                                                null) {
                                              return child;
                                            }

                                            return const SizedBox(
                                              width: 75,
                                              height: 75,
                                              child:
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth:
                                                      2,
                                                ),
                                              ),
                                            );
                                          },

                                          errorBuilder:
                                              (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 75,
                                              height: 75,
                                              color: Colors
                                                  .grey[200],
                                              child:
                                                  const Icon(
                                                Icons
                                                    .image_not_supported,
                                                size: 30,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 12,
                                    ),

                                    // ==================================================
                                    // PRODUCT INFORMATION
                                    // ==================================================
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _openProductDetails(
                                                product,
                                              );
                                            },
                                            child: Text(
                                              product.title,
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                              style:
                                                  const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 6,
                                          ),

                                          Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style:
                                                const TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          Text(
                                            'Item total: \$${itemTotal.toStringAsFixed(2)}',
                                            style:
                                                TextStyle(
                                              fontSize: 12,
                                              color: Colors
                                                  .grey[600],
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          // ==================================================
                                          // ENHANCEMENT 1:
                                          // QUANTITY CONTROLS
                                          // ==================================================
                                          Row(
                                            children: [
                                              // MINUS BUTTON
                                              SizedBox(
                                                width: 34,
                                                height: 34,
                                                child:
                                                    IconButton(
                                                  padding:
                                                      EdgeInsets
                                                          .zero,
                                                  onPressed:
                                                      quantity >
                                                              1
                                                          ? () {
                                                              _decreaseQuantity(
                                                                product,
                                                              );
                                                            }
                                                          : null,
                                                  icon:
                                                      const Icon(
                                                    Icons
                                                        .remove,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),

                                              // QUANTITY NUMBER
                                              Container(
                                                width: 35,
                                                alignment:
                                                    Alignment
                                                        .center,
                                                child: Text(
                                                  '$quantity',
                                                  style:
                                                      const TextStyle(
                                                    fontSize:
                                                        16,
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                  ),
                                                ),
                                              ),

                                              // PLUS BUTTON
                                              SizedBox(
                                                width: 34,
                                                height: 34,
                                                child:
                                                    IconButton(
                                                  padding:
                                                      EdgeInsets
                                                          .zero,
                                                  onPressed:
                                                      () {
                                                    _increaseQuantity(
                                                      product,
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(
                                                    Icons.add,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ==================================================
                    // CART SUMMARY
                    // ==================================================
                    Container(
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset:
                                const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${_getSubtotal().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Order confirmation is ready.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Confirm Order',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}