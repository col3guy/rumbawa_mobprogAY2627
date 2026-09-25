import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_screen.dart';
import 'cart_screen.dart';
import 'chat_screen.dart';

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

    _loadCurrentUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD CURRENT LOGGED-IN USER
  // ============================================================

  Future<void> _loadCurrentUser() async {
    try {
      final userService = UserService();
      final savedUser = await userService.getUserData();
      final loginType = savedUser['loginType'] ?? 'dummyjson';

      if (loginType == 'firebase') {
        if (!mounted) return;

        setState(() {
          currentUser = savedUser;
          isLoadingUser = false;
        });
        return;
      }

      final loadedUser =
          await userService.getUserById(widget.userId);

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
  // ============================================================

  Future<void> _signOut() async {
    await UserService().logout();

    if (!mounted) return;

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

    final Color appBarColor =
        isDark ? darkNavy : navy;

    return Scaffold(
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
                          color: Colors.white
                              .withValues(alpha: 0.70),
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
            ProductScreen(
              userId: widget.userId,
            ),

            CartScreen(
              userId: widget.userId,
            ),

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ChatScreen(),
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
                        navy.withValues(alpha: 0.10),
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
                  .withValues(alpha: 0.45),

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
  // ============================================================

  Widget _buildProfileScreen() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color pageBackground =
        theme.scaffoldBackgroundColor;

    final Color cardColor =
        colorScheme.surface;

    final Color mainTextColor =
        colorScheme.onSurface;

    final Color secondaryTextColor =
        colorScheme.onSurface
            .withValues(alpha: 0.60);

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
                          navy.withValues(alpha: 0.20),
                      blurRadius: 15,
                      offset:
                          const Offset(0, 7),
                    ),
                  ],
                ),

                child: Stack(
                  children: [
                    Positioned(
                      top: -45,
                      right: -45,

                      child: Container(
                        width: 120.w,
                        height: 120.h,

                        decoration:
                            BoxDecoration(
                          color: orange
                              .withValues(alpha: 0.18),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,

                        crossAxisAlignment:
                            CrossAxisAlignment.center,

                        children: [
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

                          Text(
                            username.isEmpty
                                ? '@user'
                                : '@$username',

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.70,
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

              SizedBox(height: 18.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),

                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius.circular(18.r),
                  border: Border.all(
                    color:
                        navy.withValues(alpha: 0.08),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Account actions',

                      style: TextStyle(
                        color: mainTextColor,
                        fontSize: 16.sp,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    if ((currentUser!['loginType'] ??
                            'dummyjson') ==
                        'firebase') ...[
                      _accountActionButton(
                        icon: Icons.edit,
                        label: 'Update username',
                        onTap:
                            _showUpdateUsernameDialog,
                      ),

                      SizedBox(height: 10.h),

                      _accountActionButton(
                        icon:
                            Icons.lock_reset_rounded,
                        label: 'Change password',
                        onTap:
                            _showChangePasswordDialog,
                      ),

                      SizedBox(height: 10.h),

                      _accountActionButton(
                        icon:
                            Icons.delete_forever_rounded,
                        label: 'Delete account',
                        onTap:
                            _showDeleteAccountDialog,
                        destructive: true,
                      ),
                    ] else ...[
                      Text(
                        'This account is managed by DummyJSON.\n'
                        'Use the app login flow to manage it there.',

                        style: TextStyle(
                          color:
                              secondaryTextColor,
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 12.h),

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

  Future<void> _showUpdateUsernameDialog() async {
    final controller = TextEditingController(
      text: currentUser?['username'] ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Username',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              controller.text.trim(),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    try {
      final userService = UserService();

      await userService.updateUsername(result);

      final updated =
          Map<String, dynamic>.from(
        currentUser ?? {},
      );

      updated['username'] = result;

      await userService.saveUserData(updated);

      if (!mounted) return;

      setState(() {
        currentUser = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Username updated successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final currentPasswordController =
        TextEditingController();

    final newPasswordController =
        TextEditingController();

    final confirmPasswordController =
        TextEditingController();

    final messenger =
        ScaffoldMessenger.maybeOf(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change password'),

        content: SizedBox(
          width: 350,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller:
                    currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Current password',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    newPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      'New password',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Confirm new password',
                ),
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child:
                const Text('Cancel'),
          ),

          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child:
                const Text('Update'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final currentPassword =
        currentPasswordController.text.trim();

    final newPassword =
        newPasswordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all password fields.',
          ),
        ),
      );

      return;
    }

    if (newPassword != confirmPassword) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            'New passwords do not match.',
          ),
        ),
      );

      return;
    }

    try {
      await UserService().changePassword(
        currentPassword,
        newPassword,
      );

      if (!mounted) return;

      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            'Password changed successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final emailController =
        TextEditingController(
      text: currentUser?['email'] ?? '',
    );

    final passwordController =
        TextEditingController();

    final navigator =
        Navigator.of(context);

    final messenger =
        ScaffoldMessenger.maybeOf(context);

    final confirm =
        await showDialog<bool>(
      context: context,

      builder: (context) =>
          AlertDialog(
        title:
            const Text('Delete account'),

        content: SizedBox(
          width: 350,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Text(
                'This will permanently delete your Firebase account.',
              ),

              const SizedBox(
                height: 12,
              ),

              TextField(
                controller:
                    emailController,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Email',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              TextField(
                controller:
                    passwordController,

                obscureText:
                    true,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Password',
                ),
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),

            child:
                const Text('Cancel'),
          ),

          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),

            child:
                const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await UserService().deleteAccount(
        emailController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;

      await UserService().logout();

      if (!mounted) return;

      if (navigator.mounted) {
        navigator.pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;

      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  Widget _accountActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final theme = Theme.of(context);
    final mainTextColor =
        theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(12.r),

      child: Container(
        width: double.infinity,

        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),

        decoration: BoxDecoration(
          color: destructive
              ? Colors.red
                  .withValues(alpha: 0.08)
              : lightOrange,

          borderRadius:
              BorderRadius.circular(12.r),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color:
                  destructive
                      ? Colors.red
                      : orange,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Text(
                label,

                style: TextStyle(
                  color: destructive
                      ? Colors.red
                      : mainTextColor,

                  fontWeight:
                      FontWeight.w700,

                  fontSize: 13.sp,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,

              color: destructive
                  ? Colors.red
                  : orange,
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
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,

      margin: EdgeInsets.only(
        bottom: 12.h,
      ),

      padding: EdgeInsets.all(15.w),

      decoration: BoxDecoration(
        color:
            colorScheme.surface,

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
                      navy.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 3),
                ),
              ],
      ),

      child: Row(
        children: [
          Container(
            width: 43.w,
            height: 43.h,

            decoration:
                BoxDecoration(
              color: isDark
                  ? orange.withValues(
                      alpha: 0.18,
                    )
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
                        .withValues(
                      alpha: 0.60,
                    ),
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