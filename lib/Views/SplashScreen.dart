import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart'; // Flutter Map package
import 'package:latlong2/latlong.dart'; // For storing latitude &amp; longitude
import 'package:geolocator/geolocator.dart';
import 'package:travelmate/Views/LoginScreen.dart';
import 'package:travelmate/Views/MainNavigation.dart';

import 'package:travelmate/Services/Auth/AuthServices.dart';
import '../Services/location/location_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  LatLng? currentLocation;
  final MapController _mapController = MapController();
  String statusMessage = "Loading location...";
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    _initLocation();

    // 2. Store location for later use (example using static variable)
    LocationStorage.userLocation = currentLocation;

    // 3. Navigate after delay
    _navigateToLogin();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled; // To check if GPS is ON
    LocationPermission permission; // To check location permissions
    // Check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        statusMessage =
            "GPS is OFF. Please turn it ON."; // Show message if GPS OFF
      });
      return;
    }
    // Check if app has permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Ask user for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          statusMessage =
              "Location permission denied!"; // User denied permission
        });
        return;
      }
    }
    // If permission is denied forever (cannot ask again)
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        statusMessage =
            "Location permission permanently denied! Enable in Settings.";
      });
      return;
    }
    // Try to get the last known location (fastest way)
    try {
      Position? lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null) {
        setState(() {
          currentLocation = LatLng(lastPos.latitude, lastPos.longitude);
          _mapController.move(currentLocation!, 16);
        });
      }
    } catch (e) {
      // getLastKnownPosition likely failed (e.g. on Web), ignore and proceed to getCurrentPosition
      print('getLastKnownPosition failed (expected on Web): $e');
    }
    // Get current location if last known location is not available
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ); // High accuracy location
      setState(() {
        currentLocation = LatLng(pos.latitude, pos.longitude);
        _mapController.move(
          currentLocation!,
          16,
        ); // Move map to current location
      });
    } catch (e) {
      setState(() {
        statusMessage = "Failed to get current location.";
      });
    }
    // Start listening to location changes (live tracking)
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position pos) {
      if (mounted) {
        setState(() {
          currentLocation = LatLng(pos.latitude, pos.longitude);
        });
      }
    });

    if (currentLocation != null) {
      LocationStorage.userLocation = currentLocation;
    }
  }

  // ← ADDED THIS METHOD
  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      final user = AuthService.firebase().currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00897B), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'TravelMate',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Your Journey Begins Here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
