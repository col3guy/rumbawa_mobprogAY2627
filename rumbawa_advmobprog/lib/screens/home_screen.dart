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
  // successful DummyJSON authentication.
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
  // CURRENT LOGGED-IN USER
  // ============================================================
  Map<String, dynamic>? currentUser;

  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();

    // Load the currently logged-in DummyJSON user.
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to load user information.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SIGN OUT
  //
  // Returns the user to the Login screen and removes
  // the previous HomeScreen from the navigation stack.
  // ============================================================
  void _signOut() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,

        title: _selectedIndex == 0
            ? Image.asset(
                'assets/images/nubdexchange_logo.png',
                scale: 11.sp,
              )
            : CustomText(
                text: _selectedIndex == 1
                    ? 'Cart'
                    : 'Profile',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 24.sp,
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
      // ENHANCEMENT 3:
      //
      // Products, Cart, and Profile use the currently
      // logged-in user's ID.
      // ==========================================================
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,

        children: [
          // ========================================================
          // ENHANCEMENT 3:
          // Product screen receives the logged-in user's ID.
          // ========================================================
          ProductScreen(
            userId: widget.userId,
          ),

          // ========================================================
          // ENHANCEMENT 1 & 3:
          // Cart screen displays the logged-in user's cart.
          // ========================================================
          CartScreen(
            userId: widget.userId,
          ),

          // ========================================================
          // PROFILE
          // Shows the currently logged-in user's information.
          // ========================================================
          _buildProfileScreen(),
        ],

        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),

      // ==========================================================
      // ENHANCEMENT 2:
      //
      // Chat is now a FloatingActionButton.
      // It is hidden on the Cart screen.
      // ==========================================================
      floatingActionButton: _selectedIndex != 1
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chat feature opened',
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat,
              ),
            )
          : null,

      // ==========================================================
      // ENHANCEMENT 1 & 3:
      // Products | Cart | Profile
      // ==========================================================
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onTappedBar,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shop_2,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE SCREEN
  //
  // Shows information belonging to the currently
  // logged-in DummyJSON user.
  // ============================================================
  Widget _buildProfileScreen() {
    if (isLoadingUser) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (currentUser == null) {
      return const SafeArea(
        child: Center(
          child: Text(
            'Unable to load profile.',
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 25.h,
        ),
        child: Column(
          children: [
            // ==================================================
            // USER PROFILE PICTURE
            // ==================================================
            CircleAvatar(
              radius: 50.r,
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image)
                  : null,
              child: image.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 55.sp,
                    )
                  : null,
            ),

            SizedBox(height: 16.h),

            // ==================================================
            // REAL USER NAME
            // ==================================================
            CustomText(
              text: fullName.isEmpty
                  ? 'User'
                  : fullName,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(height: 6.h),

            // ==================================================
            // USERNAME
            // ==================================================
            CustomText(
              text: username.isEmpty
                  ? '@user'
                  : '@$username',
              fontSize: 14.sp,
            ),

            SizedBox(height: 30.h),

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
              Icons.person_outline,
              'Gender',
              gender,
            ),

            SizedBox(height: 20.h),

            // ==================================================
            // SIGN OUT BUTTON
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Sign Out',
                ),
              ),
            ),
          ],
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
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 12.h,
      ),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24.sp,
          ),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  value.isEmpty
                      ? 'Not available'
                      : value,
                  style: TextStyle(
                    fontSize: 14.sp,
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