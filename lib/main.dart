import 'package:travelmate/Views/HotelDetails.dart';
import 'package:travelmate/Views/HotelList.dart';
import 'package:travelmate/Views/MapView.dart';
import 'package:travelmate/Views/MyTrips.dart';
import 'package:travelmate/Views/TouristSpotsList.dart';
import 'package:travelmate/Views/Register.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Views/Explore.dart';
import 'package:travelmate/Views/HomePage.dart';
import 'package:travelmate/Views/Profile.dart';
import 'package:travelmate/Views/Saved.dart';
import 'package:travelmate/Views/SplashScreen.dart';
import 'package:travelmate/Views/LoginScreen.dart';
import 'package:travelmate/Views/SearchResults.dart';
import 'package:travelmate/Views/Settings.dart';

import 'Utilities/AppNavigator (1).dart';
import 'Views/RouteDetails.dart';

void main() {
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

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
    HomePage(),
    Explore(),
    Saved(),
    Profile(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}