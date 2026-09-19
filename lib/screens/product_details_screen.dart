import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../widgets/custom_text.dart';

/// ============================================================
/// ENHANCEMENT 2:
/// Product Details Screen
///
/// Displays complete information about a selected product
/// using a custom navy blue, orange, and white UI.
/// ============================================================
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  /// ============================================================
  /// ENHANCEMENT 3:
  /// User ID used when adding a product to the cart.
  /// ============================================================
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
  // ============================================================
  // CUSTOM COLOR THEME
  // ============================================================
  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FC);
  static const Color textGray = Color(0xFF777777);

  final CartService _cartService = CartService();

  bool isAdding = false;

  /// ============================================================
  /// ENHANCEMENT 3:
  /// Add the selected product to the user's cart.
  ///
  /// Sends:
  /// - userId
  /// - productId
  /// - quantity
  /// ============================================================
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
          backgroundColor: navy,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: orange,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  '${widget.product.title} added to cart!',
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Failed to add product to cart.',
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isAdding = false;
      });
    }
  }

  Widget _infoSection({
    required String title,
    required String value,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(9.w),
              decoration: BoxDecoration(
                color: lightOrange,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: orange,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: background,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Product Details',
          style: TextStyle(
            color: white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: white,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======================================================
            // ENHANCEMENT 2:
            // PRODUCT IMAGE
            // ======================================================
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300.h,
                  color: Colors.grey.shade100,
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: lightOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 60.sp,
                            color: orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Product tag
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'PRODUCT',
                      style: TextStyle(
                        color: white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ======================================================
            // PRODUCT INFORMATION
            // ======================================================
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==================================================
                  // ENHANCEMENT 2:
                  // PRODUCT TITLE
                  // ==================================================
                  Text(
                    product.title,
                    style: TextStyle(
                      color: navy,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // ==================================================
                  // RATING + STOCK
                  // ==================================================
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: lightOrange,
                          borderRadius:
                              BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: orange,
                              size: 17.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              product.rating.toString(),
                              style: TextStyle(
                                color: navy,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            color: textGray,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // PRODUCT PRICE
                  // ==================================================
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: orange,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ==================================================
                  // DISCOUNT
                  // ==================================================
                  if (product.discountPercentage > 0) ...[
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: lightOrange,
                        borderRadius:
                            BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(1)}% OFF',
                        style: TextStyle(
                          color: navy,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // DESCRIPTION
                  // ==================================================
                  Text(
                    'Description',
                    style: TextStyle(
                      color: navy,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    product.description,
                    style: TextStyle(
                      color: textGray,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // ==================================================
                  // CATEGORY + BRAND
                  // ==================================================
                  Row(
                    children: [
                      Expanded(
                        child: _infoSection(
                          title: 'Category',
                          value: product.category,
                          icon: Icons.category_outlined,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _infoSection(
                          title: 'Brand',
                          value: product.brand,
                          icon: Icons.business_outlined,
                        ),
                      ),
                    ],
                  ),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // PRODUCT TAGS
                  // ==================================================
                  if (product.tags.isNotEmpty) ...[
                    SizedBox(height: 6.h),

                    Text(
                      'Tags',
                      style: TextStyle(
                        color: navy,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: product.tags.map(
                        (tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 11.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              color: lightOrange,
                              borderRadius:
                                  BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: navy,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],

                  SizedBox(height: 22.h),

                  // ==================================================
                  // WARRANTY
                  // ==================================================
                  _infoSection(
                    title: 'Warranty',
                    value: product.warrantyInformation,
                    icon: Icons.verified_outlined,
                  ),

                  // ==================================================
                  // SHIPPING
                  // ==================================================
                  _infoSection(
                    title: 'Shipping',
                    value: product.shippingInformation,
                    icon: Icons.local_shipping_outlined,
                  ),

                  // ==================================================
                  // RETURN POLICY
                  // ==================================================
                  _infoSection(
                    title: 'Return Policy',
                    value: product.returnPolicy,
                    icon: Icons.assignment_return_outlined,
                  ),

                  SizedBox(height: 10.h),

                  // ==================================================
                  // ENHANCEMENT 3:
                  // ADD TO CART BUTTON
                  //
                  // Sends:
                  // userId
                  // productId
                  // quantity
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed:
                          isAdding ? null : _addToCart,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        disabledBackgroundColor:
                            orange.withValues(alpha: 0.6),
                        foregroundColor: white,
                        elevation: 3,
                        shadowColor:
                            orange.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.r),
                        ),
                      ),

                      child: isAdding
                          ? SizedBox(
                              height: 22.h,
                              width: 22.w,
                              child:
                                  const CircularProgressIndicator(
                                color: white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 21.sp,
                                  color: white,
                                ),
                                SizedBox(width: 9.w),
                                Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}