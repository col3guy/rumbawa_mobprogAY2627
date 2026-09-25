import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// models
import '../models/product.dart';

// services
import '../services/product_service.dart';

// screens
import 'product_details_screen.dart';

/// ============================================================
/// PRODUCT SCREEN
///
/// Displays products in a searchable grid.
///
/// ENHANCEMENT 1:
/// Search functionality
///
/// ENHANCEMENT 2:
/// Clickable product cards
///
/// ENHANCEMENT 3:
/// Uses the selected user ID when opening product details.
///
/// DARK MODE:
/// Uses Theme.of(context) so the entire page changes
/// between the light and dark theme.
/// ============================================================

class ProductScreen extends StatefulWidget {
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
  // BRAND COLORS
  // ============================================================

  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _productsFuture =
        ProductService().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // THEME-AWARE COLORS
    // ==========================================================

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color pageBackground =
        theme.scaffoldBackgroundColor;

    final Color cardColor =
        colorScheme.surface;

    final Color mainTextColor =
        colorScheme.onSurface;

    final Color secondaryTextColor =
        colorScheme.onSurface.withValues(alpha: 0.60);

    final Color imageBackground = isDark
        ? const Color(0xFF25245D)
        : const Color(0xFFF1F2F7);

    return Container(
      // ==========================================================
      // WHOLE PRODUCT PAGE BACKGROUND
      // ==========================================================

      color: pageBackground,

      child: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 18.h,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =================================================
              // HEADER
              // =================================================

              Text(
                'Explore Products',
                style: TextStyle(
                  color: mainTextColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                'Find something you like from our campus marketplace.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 17.h),

              // =================================================
              // SEARCH BAR
              // =================================================

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius:
                      BorderRadius.circular(16.r),

                  border: Border.all(
                    color: isDark
                        ? Colors.white
                            .withValues(alpha: 0.08)
                        : navy.withValues(alpha: 0.08),
                  ),

                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color:
                                navy.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                ),

                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value.toLowerCase();
                    });
                  },

                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 14.sp,
                    fontWeight:
                        FontWeight.w500,
                  ),

                  decoration:
                      InputDecoration(
                    hintText:
                        'Search products...',

                    hintStyle: TextStyle(
                      color:
                          secondaryTextColor,
                      fontSize: 13.sp,
                    ),

                    border:
                        InputBorder.none,

                    contentPadding:
                        EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 5.w,
                    ),

                    prefixIcon:
                        Container(
                      margin:
                          EdgeInsets.all(8.w),

                      decoration:
                          BoxDecoration(
                        color: isDark
                            ? orange
                                .withValues(
                                alpha: 0.18,
                              )
                            : lightOrange,

                        borderRadius:
                            BorderRadius
                                .circular(
                          10.r,
                        ),
                      ),

                      child: Icon(
                        Icons.search_rounded,
                        color: orange,
                        size: 21.sp,
                      ),
                    ),

                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons
                                      .close_rounded,
                                  color:
                                      mainTextColor,
                                  size: 20.sp,
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

              SizedBox(height: 22.h),

              // =================================================
              // PRODUCTS HEADER
              // =================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      color: mainTextColor,
                      fontSize: 18.sp,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  Container(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),

                    decoration:
                        BoxDecoration(
                      color: isDark
                          ? orange.withValues(
                              alpha: 0.18,
                            )
                          : lightOrange,

                      borderRadius:
                          BorderRadius
                              .circular(
                        20.r,
                      ),
                    ),

                    child: Text(
                      'SHOP',
                      style: TextStyle(
                        color: orange,
                        fontSize: 9.sp,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // =================================================
              // LOAD PRODUCTS
              // =================================================

              FutureBuilder<List<Product>>(
                future: _productsFuture,

                builder:
                    (context, snapshot) {
                  // =================================================
                  // LOADING
                  // =================================================

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all(40.r),

                        child:
                            const CircularProgressIndicator(
                          color: orange,
                        ),
                      ),
                    );
                  }

                  // =================================================
                  // ERROR
                  // =================================================

                  if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,

                      padding:
                          EdgeInsets.all(20.w),

                      decoration:
                          BoxDecoration(
                        color: cardColor,

                        borderRadius:
                            BorderRadius
                                .circular(
                          16.r,
                        ),

                        border: Border.all(
                          color:
                              orange.withValues(
                            alpha: 0.25,
                          ),
                        ),
                      ),

                      child: Column(
                        children: [
                          Icon(
                            Icons
                                .error_outline_rounded,
                            color: orange,
                            size: 40.sp,
                          ),

                          SizedBox(
                              height: 10.h),

                          Text(
                            'Unable to load products.',
                            style: TextStyle(
                              color:
                                  mainTextColor,
                              fontSize: 14.sp,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                          SizedBox(
                              height: 5.h),

                          Text(
                            'Please check your connection and try again.',
                            textAlign:
                                TextAlign
                                    .center,
                            style: TextStyle(
                              color:
                                  secondaryTextColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final products =
                      snapshot.data ?? [];

                  // =================================================
                  // SEARCH FILTER
                  // =================================================

                  final filteredProducts =
                      products.where(
                    (product) {
                      return product.title
                              .toLowerCase()
                              .contains(
                                _searchQuery,
                              ) ||
                          product.description
                              .toLowerCase()
                              .contains(
                                _searchQuery,
                              );
                    },
                  ).toList();

                  // =================================================
                  // NO RESULTS
                  // =================================================

                  if (filteredProducts
                      .isEmpty) {
                    return Container(
                      width: double.infinity,

                      padding:
                          EdgeInsets.symmetric(
                        vertical: 45.h,
                        horizontal: 20.w,
                      ),

                      decoration:
                          BoxDecoration(
                        color: cardColor,

                        borderRadius:
                            BorderRadius
                                .circular(
                          16.r,
                        ),
                      ),

                      child: Column(
                        children: [
                          Icon(
                            Icons
                                .search_off_rounded,
                            color: orange,
                            size: 45.sp,
                          ),

                          SizedBox(
                              height: 12.h),

                          Text(
                            'No products found.',
                            style: TextStyle(
                              color:
                                  mainTextColor,
                              fontSize: 15.sp,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),

                          SizedBox(
                              height: 5.h),

                          Text(
                            'Try searching for another product.',
                            textAlign:
                                TextAlign
                                    .center,
                            style: TextStyle(
                              color:
                                  secondaryTextColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // =================================================
                  // PRODUCT GRID
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
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.68,
                    ),

                    itemBuilder:
                        (context, index) {
                      final product =
                          filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductDetailsScreen(
                                product:
                                    product,

                                // ENHANCEMENT 3:
                                // Pass logged-in user ID.
                                userId:
                                    widget.userId,
                              ),
                            ),
                          );
                        },

                        child: Container(
                          decoration:
                              BoxDecoration(
                            color: cardColor,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              18.r,
                            ),

                            border: Border.all(
                              color: isDark
                                  ? Colors.white
                                      .withValues(
                                      alpha: 0.08,
                                    )
                                  : navy.withValues(
                                      alpha: 0.06,
                                    ),
                            ),

                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: navy
                                          .withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius:
                                          10,
                                      offset:
                                          const Offset(
                                        0,
                                        4,
                                      ),
                                    ),
                                  ],
                          ),

                          child: ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18.r,
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                // =================================
                                // IMAGE
                                // =================================

                                Expanded(
                                  child:
                                      Container(
                                    width:
                                        double.infinity,

                                    color:
                                        imageBackground,

                                    child:
                                        Stack(
                                      children: [
                                        Positioned
                                            .fill(
                                          child:
                                              Image.network(
                                            product
                                                .thumbnail,

                                            fit: BoxFit
                                                .cover,

                                            errorBuilder:
                                                (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Center(
                                                child:
                                                    Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  color:
                                                      secondaryTextColor,
                                                  size:
                                                      35.sp,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // PRODUCT TAG
                                        Positioned(
                                          top: 9.h,
                                          left: 9.w,

                                          child:
                                              Container(
                                            padding:
                                                EdgeInsets.symmetric(
                                              horizontal:
                                                  7.w,
                                              vertical:
                                                  4.h,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  orange,

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                7.r,
                                              ),
                                            ),

                                            child:
                                                Text(
                                              'PRODUCT',
                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.white,
                                                fontSize:
                                                    7,
                                                fontWeight:
                                                    FontWeight.w900,
                                                letterSpacing:
                                                    0.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // =================================
                                // PRODUCT INFO
                                // =================================

                                Padding(
                                  padding:
                                      EdgeInsets.all(
                                    10.w,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      Text(
                                        product
                                            .title,

                                        maxLines: 1,

                                        overflow:
                                            TextOverflow
                                                .ellipsis,

                                        style:
                                            TextStyle(
                                          color:
                                              mainTextColor,
                                          fontSize:
                                              13.sp,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                        ),
                                      ),

                                      SizedBox(
                                          height: 6.h),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,

                                        children: [
                                          Text(
                                            '\$${product.price.toStringAsFixed(2)}',

                                            style:
                                                TextStyle(
                                              color:
                                                  orange,
                                              fontSize:
                                                  14.sp,
                                              fontWeight:
                                                  FontWeight
                                                      .w900,
                                            ),
                                          ),

                                          Container(
                                            width:
                                                28.w,
                                            height:
                                                28.h,

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  isDark
                                                      ? orange.withValues(
                                                          alpha: 0.18,
                                                        )
                                                      : lightOrange,

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                9.r,
                                              ),
                                            ),

                                            child:
                                                Icon(
                                              Icons
                                                  .arrow_forward_rounded,
                                              color:
                                                  orange,
                                              size:
                                                  17.sp,
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
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}