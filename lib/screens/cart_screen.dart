import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'product_details_screen.dart';

/// ============================================================
/// ENHANCEMENT 3:
/// Cart Screen
///
/// Displays the cart based on the logged-in user's userId.
/// Uses CartService to retrieve the user's cart.
///
/// DARK MODE:
/// Uses Theme.of(context) so the entire cart page follows
/// the application's light/dark theme.
/// ============================================================
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
  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);

  final CartService _cartService = CartService();

  Cart? cart;

  bool isLoading = true;
  bool isOpeningProduct = false;

  /// ENHANCEMENT 1:
  /// Stores the current quantity of each product.
  final Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  /// ============================================================
  /// ENHANCEMENT 3:
  /// Load cart for the logged-in user.
  /// ============================================================
  Future<void> _loadCart() async {
    try {
      final result =
          await _cartService.getCartByUserId(
        widget.userId,
      );

      if (!mounted) return;

      setState(() {
        cart = result;
        isLoading = false;

        quantities.clear();

        if (result != null) {
          for (final product
              in result.products) {
            quantities[product.id] =
                product.quantity;
          }
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      final theme = Theme.of(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              theme.brightness == Brightness.dark
                  ? orange
                  : navy,
          content: const Text(
            'Failed to load cart.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  /// ============================================================
  /// ENHANCEMENT 1:
  /// Increase product quantity.
  /// ============================================================
  void _increaseQuantity(
    CartProduct product,
  ) {
    setState(() {
      final currentQuantity =
          quantities[product.id] ??
              product.quantity;

      quantities[product.id] =
          currentQuantity + 1;
    });
  }

  /// ============================================================
  /// ENHANCEMENT 1:
  /// Decrease product quantity.
  /// ============================================================
  void _decreaseQuantity(
    CartProduct product,
  ) {
    final currentQuantity =
        quantities[product.id] ??
            product.quantity;

    if (currentQuantity <= 1) {
      return;
    }

    setState(() {
      quantities[product.id] =
          currentQuantity - 1;
    });
  }

  /// ============================================================
  /// ENHANCEMENT 1:
  /// Calculate subtotal.
  /// ============================================================
  double _getSubtotal() {
    if (cart == null) {
      return 0;
    }

    double subtotal = 0;

    for (final product
        in cart!.products) {
      final quantity =
          quantities[product.id] ??
              product.quantity;

      subtotal +=
          product.price * quantity;
    }

    return subtotal;
  }

  /// ============================================================
  /// ENHANCEMENT 2:
  /// Open Product Details.
  /// ============================================================
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
            builder: (context) =>
                ProductDetailsScreen(
              product: product,

              // ENHANCEMENT 3:
              // Pass logged-in user ID.
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

      final theme = Theme.of(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              theme.brightness ==
                      Brightness.dark
                  ? orange
                  : navy,

          content: const Text(
            'Failed to open product details.',
            style: TextStyle(
              color: Colors.white,
            ),
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

  // ============================================================
  // QUANTITY BUTTON
  // ============================================================

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    final bool isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: 32,
      height: 32,

      decoration: BoxDecoration(
        color: onPressed == null
            ? (isDark
                ? Colors.white
                    .withOpacity(0.08)
                : Colors.grey.shade200)
            : (isDark
                ? orange.withOpacity(0.18)
                : lightOrange),

        borderRadius:
            BorderRadius.circular(8),
      ),

      child: IconButton(
        padding: EdgeInsets.zero,

        onPressed: onPressed,

        icon: Icon(
          icon,
          size: 17,

          color: onPressed == null
              ? (isDark
                  ? Colors.white
                      .withOpacity(0.35)
                  : Colors.grey)
              : orange,
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _buildEmptyCart() {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      color:
          theme.scaffoldBackgroundColor,

      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(30),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                padding:
                    const EdgeInsets.all(25),

                decoration:
                    BoxDecoration(
                  color: isDark
                      ? orange.withOpacity(
                          0.18,
                        )
                      : lightOrange,

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons
                      .shopping_cart_outlined,
                  size: 65,
                  color: orange,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Your cart is empty',

                style: TextStyle(
                  color:
                      colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Browse our products and add something to your cart.',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color: colorScheme
                      .onSurface
                      .withOpacity(0.60),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CART PRODUCT CARD
  // ============================================================

  Widget _buildCartItem(
    CartProduct product,
  ) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final Color cardColor =
        colorScheme.surface;

    final Color textColor =
        colorScheme.onSurface;

    final Color secondaryText =
        colorScheme.onSurface
            .withOpacity(0.60);

    final quantity =
        quantities[product.id] ??
            product.quantity;

    final itemTotal =
        product.price * quantity;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: isDark
              ? Colors.white
                  .withOpacity(0.08)
              : Colors.grey.shade200,
        ),

        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.04),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 3),
                ),
              ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [
          // ======================================================
          // PRODUCT IMAGE
          // ======================================================

          GestureDetector(
            onTap: () {
              _openProductDetails(
                product,
              );
            },

            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              child: Image.network(
                product.thumbnail,

                width: 82,
                height: 82,

                fit: BoxFit.cover,

                loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                ) {
                  if (loadingProgress ==
                      null) {
                    return child;
                  }

                  return Container(
                    width: 82,
                    height: 82,

                    color: isDark
                        ? const Color(
                            0xFF25245D,
                          )
                        : Colors.grey
                            .shade100,

                    child:
                        const Center(
                      child:
                          CircularProgressIndicator(
                        color: orange,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 82,
                    height: 82,

                    color: isDark
                        ? orange.withOpacity(
                            0.18,
                          )
                        : lightOrange,

                    child: const Icon(
                      Icons
                          .image_not_supported_outlined,
                      size: 32,
                      color: orange,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ======================================================
          // PRODUCT INFORMATION
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',

                  style:
                      const TextStyle(
                    color: orange,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Item total: \$${itemTotal.toStringAsFixed(2)}',

                  style: TextStyle(
                    color:
                        secondaryText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 9),

                // ==================================================
                // QUANTITY CONTROLS
                // ==================================================

                Row(
                  children: [
                    _quantityButton(
                      icon:
                          Icons.remove,

                      onPressed:
                          quantity > 1
                              ? () {
                                  _decreaseQuantity(
                                    product,
                                  );
                                }
                              : null,
                    ),

                    Container(
                      width: 38,

                      alignment:
                          Alignment.center,

                      child: Text(
                        '$quantity',

                        style:
                            TextStyle(
                          color:
                              textColor,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    _quantityButton(
                      icon:
                          Icons.add,

                      onPressed: () {
                        _increaseQuantity(
                          product,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CART SUMMARY
  // ============================================================

  Widget _buildCartSummary() {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final subtotal =
        _getSubtotal();

    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        18,
      ),

      decoration: BoxDecoration(
        color:
            colorScheme.surface,

        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.08),
                  blurRadius: 10,
                  offset:
                      const Offset(0, -3),
                ),
              ],
      ),

      child: SafeArea(
        top: false,

        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                Text(
                  'Subtotal',

                  style: TextStyle(
                    color:
                        colorScheme
                            .onSurface,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                Text(
                  '\$${subtotal.toStringAsFixed(2)}',

                  style:
                      const TextStyle(
                    color: orange,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ==================================================
            // CONFIRM ORDER
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,

              child:
                  ElevatedButton(
                onPressed: () {
                  final bool isDark =
                      Theme.of(context)
                              .brightness ==
                          Brightness.dark;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          isDark
                              ? orange
                              : navy,

                      behavior:
                          SnackBarBehavior
                              .floating,

                      content:
                          const Text(
                        'Order confirmation is ready.',

                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),
                  );
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      orange,

                  foregroundColor:
                      Colors.white,

                  elevation: 3,

                  shadowColor:
                      orange.withOpacity(
                    0.3,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    Icon(
                      Icons
                          .receipt_long_outlined,
                      color:
                          Colors.white,
                    ),

                    SizedBox(width: 9),

                    Text(
                      'Confirm Order',

                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final Color pageBackground =
        theme.scaffoldBackgroundColor;

    final Color appBarColor =
        isDark ? darkNavy : navy;

    final bool hasItems =
        cart != null &&
            cart!.products.isNotEmpty;

    return Scaffold(
      // ==========================================================
      // WHOLE CART PAGE BACKGROUND
      // ==========================================================

      backgroundColor:
          pageBackground,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor:
            appBarColor,

        foregroundColor:
            Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          'My Cart',

          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: Container(
        color: pageBackground,

        child: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color: orange,
                ),
              )

            : !hasItems
                ? _buildEmptyCart()

                : Column(
                    children: [
                      // ==========================================
                      // CART HEADER
                      // ==========================================

                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          16,
                          16,
                          16,
                          12,
                        ),

                        color:
                            pageBackground,

                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .shopping_bag_outlined,
                              color: orange,
                              size: 22,
                            ),

                            const SizedBox(
                                width: 8),

                            Text(
                              '${cart!.products.length} item${cart!.products.length == 1 ? '' : 's'} in your cart',

                              style:
                                  TextStyle(
                                color:
                                    colorScheme
                                        .onSurface,
                                fontSize: 15,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==========================================
                      // PRODUCT LIST
                      // ==========================================

                      Expanded(
                        child:
                            RefreshIndicator(
                          color: orange,

                          onRefresh:
                              _loadCart,

                          child:
                              ListView.builder(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                              16,
                              4,
                              16,
                              16,
                            ),

                            itemCount:
                                cart!.products
                                    .length,

                            itemBuilder:
                                (context,
                                    index) {
                              final product =
                                  cart!.products[
                                      index];

                              return _buildCartItem(
                                product,
                              );
                            },
                          ),
                        ),
                      ),

                      // ==========================================
                      // SUMMARY
                      // ==========================================

                      _buildCartSummary(),
                    ],
                  ),
      ),
    );
  }
}