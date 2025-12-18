import 'package:flutter/material.dart';
import 'package:travelmate/Views/Explore.dart';
import 'package:travelmate/Views/HomePage.dart';
import 'package:travelmate/Views/Profile.dart';
import 'package:travelmate/Views/Saved.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  static void switchTab(BuildContext context, int index) {
    context.findAncestorStateOfType<MainNavigationState>()?.updateIndex(index);
  }

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void updateIndex(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
        break;
      case 1:
        _navigatorKey.currentState?.pushNamed('/explore');
        break;
      case 2:
        _navigatorKey.currentState?.pushNamed('/saved');
        break;
      case 3:
        _navigatorKey.currentState?.pushNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            Widget page;
            switch (settings.name) {
              case '/':
                page = const HomePage();
                break;
              case '/explore':
                page = const Explore();
                break;
              case '/saved':
                page = const Saved();
                break;
              case '/profile':
                page = const Profile();
                break;
              default:
                page = const HomePage();
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => page,
            );
          },
          // Use observer to update bottom nav index when popping
          observers: [
            _TabNavigatorObserver(
              onRouteChanged: (routeName) {
                int newIndex = _selectedIndex;
                if (routeName == '/')
                  newIndex = 0;
                else if (routeName == '/explore')
                  newIndex = 1;
                else if (routeName == '/saved')
                  newIndex = 2;
                else if (routeName == '/profile')
                  newIndex = 3;

                if (newIndex != _selectedIndex) {
                  setState(() => _selectedIndex = newIndex);
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: updateIndex,
          selectedItemColor: const Color(0xFF00897B),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  final Function(String?) onRouteChanged;

  _TabNavigatorObserver({required this.onRouteChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      onRouteChanged(previousRoute.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      onRouteChanged(newRoute.settings.name);
    }
  }
}
