import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// models
import '../models/product.dart';

// services
import '../services/product_service.dart';

// screens
import 'product_details_screen.dart';

// widgets
import '../widgets/custom_text.dart';

/// ENHANCEMENT 1: Product Screen with Search Functionality
/// This screen displays a list of products in a grid layout.
///
/// Features:
/// - ENHANCEMENT 1: Search bar to filter products by title or description
/// - ENHANCEMENT 2: Clickable product cards that navigate to details page
/// - ENHANCEMENT 3: Uses the selected DummyJSON user ID when adding to cart
class ProductScreen extends StatefulWidget {
  // ============================================================
  // ENHANCEMENT 3:
  // DummyJSON user ID currently selected in HomeScreen.
  //
  // Since this app does not have a login system,
  // HomeScreen allows the user to manually select the user ID.
  // ============================================================
  final int userId;

  const ProductScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final Future<List<Product>> _productsFuture;

  // ============================================================
  // ENHANCEMENT 1:
  // Stores the current search query.
  // ============================================================
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _productsFuture =
        ProductService().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =====================================================
            // ENHANCEMENT 1:
            // Search Bar
            // =====================================================
            Container(
              width: ScreenUtil().screenWidth,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery =
                        value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText:
                      'Search products...',
                  border: InputBorder.none,
                  prefixIcon:
                      const Icon(Icons.search),

                  // ENHANCEMENT 1:
                  // Clear search button
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery =
                                      '';
                                });
                              },
                            )
                          : null,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // =====================================================
            // Load Products
            // =====================================================
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                // =================================================
                // Loading
                // =================================================
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(32.r),
                      child:
                          const CircularProgressIndicator(),
                    ),
                  );
                }

                // =================================================
                // Error
                // =================================================
                if (snapshot.hasError) {
                  return Center(
                    child: CustomText(
                      text:
                          'Error: ${snapshot.error}',
                      fontSize: 14.sp,
                    ),
                  );
                }

                final products =
                    snapshot.data ?? [];

                // =================================================
                // ENHANCEMENT 1:
                // Product Filtering
                // =================================================
                final filteredProducts =
                    products
                        .where(
                          (product) =>
                              product.title
                                  .toLowerCase()
                                  .contains(
                                    _searchQuery,
                                  ) ||
                              product.description
                                  .toLowerCase()
                                  .contains(
                                    _searchQuery,
                                  ),
                        )
                        .toList();

                // =================================================
                // No Search Results
                // =================================================
                if (filteredProducts.isEmpty) {
                  return Center(
                    child: CustomText(
                      text:
                          'No products found.',
                      fontSize: 14.sp,
                    ),
                  );
                }

                // =================================================
                // Product Grid
                // =================================================
                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      filteredProducts.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder:
                      (context, index) {
                    final product =
                        filteredProducts[index];

                    // =============================================
                    // ENHANCEMENT 2:
                    // Clickable Product Card
                    // =============================================
                    return GestureDetector(
                      onTap: () {
                        // =========================================
                        // ENHANCEMENT 2:
                        // Navigate to Product Details
                        //
                        // ENHANCEMENT 3:
                        // Pass the selected DummyJSON user ID.
                        // =========================================
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(
                              product: product,

                              // ENHANCEMENT 3:
                              // Use the current user ID
                              // selected in HomeScreen.
                              userId:
                                  widget.userId,
                            ),
                          ),
                        );
                      },

                      child: Card(
                        elevation: 2,
                        clipBehavior:
                            Clip.antiAlias,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12.r,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            // ===================================
                            // Product Image
                            // ===================================
                            Expanded(
                              child:
                                  Image.network(
                                product.thumbnail,
                                fit: BoxFit.cover,
                                width:
                                    double.infinity,
                                errorBuilder:
                                    (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Icon(
                                    Icons
                                        .image,
                                    size:
                                        24.sp,
                                  );
                                },
                              ),
                            ),

                            // ===================================
                            // Product Information
                            // ===================================
                            Padding(
                              padding:
                                  EdgeInsets.all(
                                8.r,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  CustomText(
                                    text:
                                        product
                                            .title,
                                    fontSize:
                                        14.sp,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                  ),

                                  SizedBox(
                                    height: 4.h,
                                  ),

                                  CustomText(
                                    text:
                                        '\$${product.price.toStringAsFixed(2)}',
                                    fontSize:
                                        13.sp,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}