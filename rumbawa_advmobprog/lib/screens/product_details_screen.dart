import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../widgets/custom_text.dart';

/// ============================================================
/// ENHANCEMENT 2:
/// Product Details Screen
///
/// Displays complete information about a selected product.
/// ============================================================
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  /// ============================================================
  /// ENHANCEMENT 3:
  /// User ID used when adding a product to the cart.
  /// Currently using DummyJSON user ID 1.
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
  final CartService _cartService = CartService();

  bool isAdding = false;

  /// ============================================================
  /// ENHANCEMENT 3:
  /// Add the selected product to the user's cart.
  ///
  /// The following values are passed:
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
          content: Text(
            '${widget.product.title} added to cart!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to add product to cart.',
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

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        automaticallyImplyLeading: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // ENHANCEMENT 2:
            // Product Image
            // ==================================================
            Container(
              width: double.infinity,
              height: 300.h,
              color: Colors.grey.shade200,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Center(
                    child: Icon(
                      Icons.image,
                      size: 80.sp,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Product Title
                  // ==================================================
                  CustomText(
                    text: product.title,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 8.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Rating and Stock
                  // ==================================================
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20.sp,
                      ),

                      SizedBox(width: 4.w),

                      CustomText(
                        text: product.rating.toString(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(width: 16.w),

                      CustomText(
                        text: 'Stock: ${product.stock}',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Product Price
                  // ==================================================
                  CustomText(
                    text:
                        '\$${product.price.toStringAsFixed(2)}',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 8.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Discount
                  // ==================================================
                  if (product.discountPercentage > 0)
                    CustomText(
                      text:
                          'Discount: ${product.discountPercentage.toStringAsFixed(1)}%',
                      fontSize: 14.sp,
                    ),

                  SizedBox(height: 16.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Description
                  // ==================================================
                  CustomText(
                    text: 'Description',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 8.h),

                  CustomText(
                    text: product.description,
                    fontSize: 14.sp,
                    maxLines: null,
                  ),

                  SizedBox(height: 16.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Category and Brand
                  // ==================================================
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Category',
                            fontSize: 12.sp,
                          ),

                          CustomText(
                            text: product.category,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Brand',
                            fontSize: 12.sp,
                          ),

                          CustomText(
                            text: product.brand,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Product Tags
                  // ==================================================
                  Wrap(
                    spacing: 8.w,
                    children: product.tags
                        .map(
                          (tag) => Chip(
                            label: CustomText(
                              text: tag,
                              fontSize: 12.sp,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  SizedBox(height: 16.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Warranty
                  // ==================================================
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Warranty',
                        fontSize: 12.sp,
                      ),

                      CustomText(
                        text: product.warrantyInformation,
                        fontSize: 14.sp,
                        maxLines: 2,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Shipping
                  // ==================================================
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Shipping',
                        fontSize: 12.sp,
                      ),

                      CustomText(
                        text: product.shippingInformation,
                        fontSize: 14.sp,
                        maxLines: 2,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // ==================================================
                  // ENHANCEMENT 2:
                  // Return Policy
                  // ==================================================
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Return Policy',
                        fontSize: 12.sp,
                      ),

                      CustomText(
                        text: product.returnPolicy,
                        fontSize: 14.sp,
                        maxLines: 2,
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // ==================================================
                  // ENHANCEMENT 3:
                  // ADD TO CART BUTTON
                  //
                  // Sends the following to CartService:
                  // userId = 1
                  // productId = selected product ID
                  // quantity = 1
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isAdding ? null : _addToCart,

                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                        ),
                      ),

                      child: isAdding
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child:
                                  const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : CustomText(
                              text: 'Add to Cart',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}