import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../widgets/custom_text.dart';

/// ENHANCEMENT 2: Product Details Screen
/// This screen displays comprehensive information about a selected product.
/// 
/// Features:
/// - Full product image display
/// - Product title, rating, and stock information
/// - Price and discount details
/// - Complete product description
/// - Category and brand information
/// - Product tags/features
/// - Warranty and shipping information
/// - Return policy details
/// - "Add to Cart" button with confirmation
/// 
/// This screen is opened when a user taps on a product card from the product list.
class ProductDetailsScreen extends StatelessWidget {
  /// The product object passed from the ProductScreen
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ENHANCEMENT 2: Product Image Section
            /// Displays the product thumbnail image
            /// - Width: Full screen width
            /// - Height: 300 units
            /// - Shows error icon if image fails to load
            Container(
              width: double.infinity,
              height: 300.h,
              color: Colors.grey.shade200,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.image, size: 80.sp),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ENHANCEMENT 2: Product Title
                  /// Displays the product name in large, bold text
                  CustomText(
                    text: product.title,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 8.h),

                  /// ENHANCEMENT 2: Rating and Stock Information
                  /// Displays a star icon with the product rating and current stock
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20.sp),
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

                  /// ENHANCEMENT 2: Product Price Display
                  /// Shows the price in large, bold green text
                  CustomText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 8.h),

                  /// ENHANCEMENT 2: Discount Display (if applicable)
                  /// Shows discount percentage only if product has a discount
                  if (product.discountPercentage > 0)
                    CustomText(
                      text:
                          'Discount: ${product.discountPercentage.toStringAsFixed(1)}%',
                      fontSize: 14.sp,
                    ),

                  SizedBox(height: 16.h),

                  /// ENHANCEMENT 2: Product Description Section
                  /// Shows detailed product description with full text wrapping
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

                  /// ENHANCEMENT 2: Category and Brand Information
                  /// Displays the product category and brand in side-by-side columns
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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

                  /// ENHANCEMENT 2: Product Tags/Features
                  /// Displays product tags as interactive chips
                  /// Each tag represents a product feature or characteristic
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

                  /// ENHANCEMENT 2: Warranty, Shipping, and Return Policy Information
                  /// Displays important product policies and warranty details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  /// ENHANCEMENT 2: Shipping Information
                  /// Shows shipping details and delivery information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  /// ENHANCEMENT 2: Return Policy Information
                  /// Displays the product return policy to inform customers
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  /// ENHANCEMENT 2: Add to Cart Button
                  /// Allows users to add the product to their shopping cart.
                  /// Shows a confirmation message (SnackBar) when clicked.
                  /// In a real app, this would update a cart state/provider.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        /// Displays a confirmation message when product is added
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: CustomText(
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
