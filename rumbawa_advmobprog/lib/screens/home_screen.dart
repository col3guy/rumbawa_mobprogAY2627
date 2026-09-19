import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_screen.dart';
import 'cart_screen.dart';

import '../widgets/custom_text.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  // ============================================================
  // LOGGED-IN USER
  //
  // The user ID comes from the LoginScreen after
  // successful authentication.
  // ============================================================

  final int userId;

  const HomeScreen({
    super.key,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  // ============================================================
  // NU BD EXCHANGE BRAND COLORS
  // ============================================================

  static const Color navy = Color(0xFF1A1953);
  static const Color darkNavy = Color(0xFF11103B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color lightOrange = Color(0xFFFFE3D2);

  // ============================================================
  // CURRENT LOGGED-IN USER
  // ============================================================

  Map<String, dynamic>? currentUser;

  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();

    // Load the currently logged-in user.
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD CURRENT LOGGED-IN USER
  //
  // Uses the user ID received from LoginScreen.
  // ============================================================

  Future<void> _loadCurrentUser() async {
    try {
      final loadedUser =
          await UserService().getUserById(widget.userId);

      if (!mounted) return;

      setState(() {
        currentUser = loadedUser;
        isLoadingUser = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingUser = false;
      });

      final theme = Theme.of(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to load user information.',
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }

  // ============================================================
  // SIGN OUT
  //
  // IMPORTANT:
  // Clear the saved authentication data before going to
  // the login page.
  //
  // This allows persistent authentication to work:
  //
  // LOGIN + RESTART = STAY LOGGED IN
  //
  // LOGOUT + RESTART = LOGIN PAGE
  // ============================================================

  Future<void> _signOut() async {
    // Clear the saved token and user information.
    await UserService().logout();

    // Make sure the screen is still active.
    if (!mounted) return;

    // Remove all previous pages and return to LoginScreen.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    // ============================================================
    // THEME-AWARE COLORS
    // ============================================================

    final Color pageBackground =
        theme.scaffoldBackgroundColor;

    final Color cardColor =
        colorScheme.surface;

    final Color mainTextColor =
        colorScheme.onSurface;

    final Color secondaryTextColor =
        colorScheme.onSurface.withOpacity(0.60);

    final Color appBarColor =
        isDark ? darkNavy : navy;

    return Scaffold(
      // ==========================================================
      // WHOLE PAGE BACKGROUND
      // ==========================================================

      backgroundColor: pageBackground,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,

        title: _selectedIndex == 0
            ? Row(
                children: [
                  // Logo
                  Container(
                    width: 40.w,
                    height: 40.h,
                    padding: EdgeInsets.all(6.w),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12.r),
                      border: Border.all(
                        color: orange,
                        width: 2,
                      ),
                    ),

                    child: Image.asset(
                      'assets/images/nubdexchange_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(width: 11.w),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'NU BD EXCHANGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        'Campus Marketplace',
                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(0.70),
                          fontSize: 9.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 5.w,
                    height: 27.h,

                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius:
                          BorderRadius.circular(10.r),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  CustomText(
                    text: _selectedIndex == 1
                        ? 'Cart'
                        : 'Profile',
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              size: 24.sp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),

      // ==========================================================
      // PAGE CONTENT
      // ==========================================================

      body: Container(
        color: pageBackground,

        child: PageView(
          physics:
              const NeverScrollableScrollPhysics(),

          controller: _pageController,

          children: [
            // ====================================================
            // PRODUCT SCREEN
            // ====================================================

            ProductScreen(
              userId: widget.userId,
            ),

            // ====================================================
            // CART SCREEN
            // ====================================================

            CartScreen(
              userId: widget.userId,
            ),

            // ====================================================
            // PROFILE
            // ====================================================

            _buildProfileScreen(),
          ],

          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
        ),
      ),

      // ==========================================================
      // CHAT BUTTON
      // ==========================================================

      floatingActionButton: _selectedIndex != 1
          ? FloatingActionButton(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 5,

              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Chat feature opened',
                    ),
                    backgroundColor: appBarColor,
                  ),
                );
              },

              child: const Icon(
                Icons.chat_bubble_rounded,
              ),
            )
          : null,

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,

          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color:
                        navy.withOpacity(0.10),
                    blurRadius: 15,
                    offset:
                        const Offset(0, -4),
                  ),
                ],
        ),

        child: BottomNavigationBar(
          backgroundColor: cardColor,

          elevation: 0,

          type:
              BottomNavigationBarType.fixed,

          currentIndex: _selectedIndex,

          selectedItemColor: orange,

          unselectedItemColor:
              colorScheme.onSurface
                  .withOpacity(0.45),

          selectedIconTheme:
              IconThemeData(
            size: 27.sp,
          ),

          unselectedIconTheme:
              IconThemeData(
            size: 24.sp,
          ),

          selectedLabelStyle:
              TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
          ),

          unselectedLabelStyle:
              TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),

          showSelectedLabels: true,
          showUnselectedLabels: true,

          onTap: _onTappedBar,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
              ),
              activeIcon: Icon(
                Icons.storefront_rounded,
              ),
              label: 'Shop',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              activeIcon: Icon(
                Icons.shopping_cart_rounded,
              ),
              label: 'Cart',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline_rounded,
              ),
              activeIcon: Icon(
                Icons.person_rounded,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE SCREEN
  //
  // Shows information belonging to the currently
  // logged-in user.
  // ============================================================

  Widget _buildProfileScreen() {
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
        colorScheme.onSurface.withOpacity(0.60);

    if (isLoadingUser) {
      return Container(
        color: pageBackground,

        child: Center(
          child: CircularProgressIndicator(
            color: orange,
          ),
        ),
      );
    }

    if (currentUser == null) {
      return Container(
        color: pageBackground,

        child: Center(
          child: Text(
            'Unable to load profile.',
            style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final String firstName =
        currentUser!['firstName'] ?? '';

    final String lastName =
        currentUser!['lastName'] ?? '';

    final String username =
        currentUser!['username'] ?? '';

    final String email =
        currentUser!['email'] ?? '';

    final String phone =
        currentUser!['phone'] ?? '';

    final String gender =
        currentUser!['gender'] ?? '';

    final String image =
        currentUser!['image'] ?? '';

    final String fullName =
        '$firstName $lastName'.trim();

    return Container(
      color: pageBackground,

      child: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 22.h,
          ),

          child: Column(
            children: [
              // ==================================================
              // PROFILE HEADER CARD
              // ==================================================

              Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(
                  vertical: 25.h,
                  horizontal: 20.w,
                ),

                decoration: BoxDecoration(
                  color: navy,

                  borderRadius:
                      BorderRadius.circular(25.r),

                  boxShadow: [
                    BoxShadow(
                      color:
                          navy.withOpacity(0.20),
                      blurRadius: 15,
                      offset:
                          const Offset(0, 7),
                    ),
                  ],
                ),

                child: Stack(
                  children: [
                    // Decorative orange circle
                    Positioned(
                      top: -45,
                      right: -45,

                      child: Container(
                        width: 120.w,
                        height: 120.h,

                        decoration:
                            BoxDecoration(
                          color: orange
                              .withOpacity(0.18),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    // ==================================================
                    // CENTERED PROFILE CONTENT
                    // ==================================================

                    Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,

                        crossAxisAlignment:
                            CrossAxisAlignment.center,

                        children: [
                          // ==================================================
                          // PROFILE PICTURE
                          // ==================================================

                          Container(
                            padding:
                                EdgeInsets.all(4.w),

                            decoration:
                                const BoxDecoration(
                              color: orange,
                              shape:
                                  BoxShape.circle,
                            ),

                            child: CircleAvatar(
                              radius: 49.r,

                              backgroundColor:
                                  cardColor,

                              backgroundImage:
                                  image.isNotEmpty
                                      ? NetworkImage(
                                          image,
                                        )
                                      : null,

                              child: image.isEmpty
                                  ? Icon(
                                      Icons.person,
                                      size: 55.sp,
                                      color:
                                          navy,
                                    )
                                  : null,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          // ==================================================
                          // NAME
                          // ==================================================

                          Text(
                            fullName.isEmpty
                                ? 'User'
                                : fullName,

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 22.sp,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),

                          SizedBox(height: 5.h),

                          // ==================================================
                          // USERNAME
                          // ==================================================

                          Text(
                            username.isEmpty
                                ? '@user'
                                : '@$username',

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(
                                0.70,
                              ),
                              fontSize: 13.sp,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          Container(
                            width: 45.w,
                            height: 4.h,

                            decoration:
                                BoxDecoration(
                              color: orange,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              // ==================================================
              // INFORMATION TITLE
              // ==================================================

              Align(
                alignment:
                    Alignment.centerLeft,

                child: Row(
                  children: [
                    Container(
                      width: 5.w,
                      height: 23.h,

                      decoration:
                          BoxDecoration(
                        color: orange,
                        borderRadius:
                            BorderRadius.circular(
                          10.r,
                        ),
                      ),
                    ),

                    SizedBox(width: 9.w),

                    Text(
                      'Personal Information',

                      style: TextStyle(
                        color:
                            mainTextColor,
                        fontSize: 18.sp,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // ==================================================
              // USER INFORMATION
              // ==================================================

              _profileInfo(
                Icons.email_outlined,
                'Email',
                email,
              ),

              _profileInfo(
                Icons.phone_outlined,
                'Phone',
                phone,
              ),

              _profileInfo(
                Icons.person_outline_rounded,
                'Gender',
                gender,
              ),

              SizedBox(height: 12.h),

              // ==================================================
              // SIGN OUT BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 53.h,

                child:
                    ElevatedButton.icon(
                  onPressed: _signOut,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor:
                        Colors.white,

                    elevation: 3,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15.r,
                      ),
                    ),
                  ),

                  icon: const Icon(
                    Icons.logout_rounded,
                  ),

                  label: Text(
                    'Sign Out',

                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              Text(
                'NU BD Exchange',

                style: TextStyle(
                  color:
                      secondaryTextColor,
                  fontSize: 11.sp,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE INFORMATION ITEM
  // ============================================================

  Widget _profileInfo(
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      margin: EdgeInsets.only(
        bottom: 12.h,
      ),

      padding: EdgeInsets.all(15.w),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius:
            BorderRadius.circular(16.r),

        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : navy.withOpacity(0.08),
        ),

        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color:
                      navy.withOpacity(0.04),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 3),
                ),
              ],
      ),

      child: Row(
        children: [
          // Orange icon container
          Container(
            width: 43.w,
            height: 43.h,

            decoration: BoxDecoration(
              color: isDark
                  ? orange.withOpacity(0.18)
                  : lightOrange,

              borderRadius:
                  BorderRadius.circular(
                13.r,
              ),
            ),

            child: Icon(
              icon,
              size: 22.sp,
              color: orange,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight:
                        FontWeight.w700,

                    color: colorScheme
                        .onSurface
                        .withOpacity(0.60),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  value.isEmpty
                      ? 'Not available'
                      : value,

                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        FontWeight.w600,

                    color:
                        colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION HANDLER
  // ============================================================

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });

    _pageController.jumpToPage(
      value,
    );
  }
}