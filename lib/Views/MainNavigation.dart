import 'package:flutter/material.dart';
import 'package:travelmate/Views/Explore.dart';
import 'package:travelmate/Views/HomePage.dart';
import 'package:travelmate/Views/Profile.dart';
import 'package:travelmate/Views/Saved.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  static final GlobalKey<MainNavigationState> globalKey =
      GlobalKey<MainNavigationState>();

  const MainNavigation({super.key, this.initialIndex = 0});

  static void switchTab(int index) {
    globalKey.currentState?.updateIndex(index);
  }

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _views = const [HomePage(), Explore(), Saved(), Profile()];

  void updateIndex(int index) {
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
        onTap: updateIndex,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
