import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';

import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(
    fileName: 'assets/.env',
  );

  runApp(
    const RoblesAdvMobProg(),
  );
}

class RoblesAdvMobProg extends StatelessWidget {
  const RoblesAdvMobProg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ScreenUtilInit(
        designSize: const Size(412, 715),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeModel =
              Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Commerce App',

            theme: themeModel.lightTheme,
            darkTheme: themeModel.darkTheme,

            themeMode: themeModel.isDark
                ? ThemeMode.dark
                : ThemeMode.light,

            // ====================================================
            // LOGIN
            // The application now starts with the Login screen.
            // After successful login, LoginScreen opens HomeScreen
            // and passes the logged-in user's ID.
            // ====================================================
            initialRoute: '/login',

            routes: {
              '/login': (context) => const LoginScreen(),

              '/settings': (context) => SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}