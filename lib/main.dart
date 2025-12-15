import 'package:flutter/material.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Views/SplashScreen.dart';
import 'package:travelmate/Utilities/AppNavigator (1).dart';

// Removed unused MainNavigation import as per lint, but ensuring check.
// If AppNavigator references routes that use MainNavigation internally logic wise, fine.
// But as per lint MainNavigation is unused in main.dart itself.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  final authService = AuthService.firebase();
  await authService.initialize();

  runApp(const TravelMate());
}

class TravelMate extends StatelessWidget {
  const TravelMate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal.shade600,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: AppNavigator.generateRoute,
      home: const SplashScreen(),
    );
  }
}
