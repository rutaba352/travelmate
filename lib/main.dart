import 'package:flutter/material.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Views/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Services/ThemeService.dart';
import 'package:travelmate/Utilities/AppTheme.dart';
import 'package:travelmate/Utilities/AppNavigator.dart';

// Removed unused MainNavigation import as per lint, but ensuring check.
// If AppNavigator references routes that use MainNavigation internally logic wise, fine.
// But as per lint MainNavigation is unused in main.dart itself.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    final authService = AuthService.firebase();
    await authService.initialize();
  } catch (e) {
    print('Error initializing app: $e');
    // You might want to run a simple error app here if initialization fails
    // runApp(ErrorApp(error: e.toString()));
  }

  runApp(const TravelMate());
}

class TravelMate extends StatelessWidget {
  const TravelMate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'TravelMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            initialRoute: '/',
            onGenerateRoute: AppNavigator.generateRoute,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
