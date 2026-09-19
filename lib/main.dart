import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

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
            title: 'NU BD Exchange',

            theme: themeModel.lightTheme,
            darkTheme: themeModel.darkTheme,

            themeMode: themeModel.isDark
                ? ThemeMode.dark
                : ThemeMode.light,

            // ENHANCEMENT 1:
            // Start the application with the custom splash screen.
            initialRoute: '/splash',

            routes: {
              '/splash': (context) =>
                  const SplashScreen(),

              '/login': (context) =>
                  const LoginScreen(),

              '/settings': (context) =>
                  SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}