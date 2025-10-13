import 'package:flutter/material.dart';
import 'package:travelmate/Views/HomePage.dart';
import 'package:travelmate/Views/Explore.dart';
import 'package:travelmate/Views/Saved.dart';
import 'package:travelmate/Views/MyTrips.dart';
import 'package:travelmate/Views/Profile.dart';

/// AppNavigator class handles all navigation routes in the application
class AppNavigator {
  // Private constructor
  AppNavigator._();

  // Route names (constants for named routes)
  static const String home = '/';
  static const String explore = '/explore';
  static const String saved = '/saved';
  static const String myTrips = '/my-trips';
  static const String profile = '/profile';
  static const String tripDetails = '/trip-details';
  static const String destinationDetails = '/destination-details';
  static const String searchResults = '/search-results';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  /// Generate route based on route name and arguments
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomePage());

      case explore:
        return _buildRoute(const Explore());

      case saved:
        return _buildRoute(const Saved());

      case myTrips:
        return _buildRoute(const MyTrips());

      case profile:
        return _buildRoute(const Profile());

      case tripDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          TripDetailsPage(tripData: args ?? {}),
        );

      case destinationDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          DestinationDetailsPage(destination: args ?? {}),
        );

      case searchResults:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          SearchResultsPage(query: args?['query'] ?? ''),
        );

      case notifications:
        return _buildRoute(const NotificationsPage());

      // case settings:
      //   return _buildRoute(const SettingsPage());

      default:
        return _buildRoute(const HomePage());
    }
  }

  /// Build a route with slide animation
  static Route<dynamic> _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Navigate to a named route
  static Future<dynamic> navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  static Future<dynamic> navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<dynamic> navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Pop multiple times
  static void popMultiple(BuildContext context, int count) {
    for (int i = 0; i < count; i++) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}

// ===== Placeholder Pages for Additional Routes =====

/// Trip Details Page
class TripDetailsPage extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripDetailsPage({
    Key? key,
    required this.tripData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: Center(
        child: Text(
          'Trip: ${tripData['title'] ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// Destination Details Page
class DestinationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> destination;

  const DestinationDetailsPage({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destination Details'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: Center(
        child: Text(
          'Destination: ${destination['name'] ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// Search Results Page
class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: $query'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: Center(
        child: Text(
          'Results for: $query',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// Notifications Page
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}

/// Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}