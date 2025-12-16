import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:travelmate/Utilities/Widgets.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Views/SearchResults.dart';
import 'package:travelmate/Views/SpotDetails.dart';
import 'package:travelmate/Views/TouristSpotsList.dart';
import 'package:travelmate/Views/HotelList.dart';

import '../Services/location/location_storage.dart';
import 'package:travelmate/Services/SearchHistoryService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController startLocationController;
  late TextEditingController destinationController;
  bool isLoading = false;
  bool hasError = false;
  bool showEmptyState = false;

  final SearchHistoryService _searchHistoryService = SearchHistoryService();
  List<Map<String, String>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    startLocationController = TextEditingController();
    destinationController = TextEditingController();
    _loadInitialData();
    _loadRecentSearches();

    // Reset loading when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = false;
        });
      }
    });
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _searchHistoryService.getSearches();
    if (mounted) {
      setState(() {
        _recentSearches = searches;
      });
    }
  }

  Future<void> _clearAllSearches() async {
    await _searchHistoryService.clearSearches();
    _loadRecentSearches();
  }

  Future<void> _deleteSearch(int index) async {
    await _searchHistoryService.deleteSearch(index);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    startLocationController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      bool simulateError = false;

      if (simulateError) {
        throw Exception('Failed to load data');
      }

      setState(() {
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
      if (mounted) {
        SnackbarHelper.showError(
          context,
          'Failed to load destinations',
          onRetry: _loadInitialData,
        );
      }
    }

    int attempts = 0;
    while (LocationStorage.userLocation == null && attempts < 5) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      attempts++;
    }

    if (LocationStorage.userLocation != null && mounted) {
      try {
        String address = await _getAddressFromLatLng(
          LocationStorage.userLocation!,
        );
        if (mounted && address.isNotEmpty) {
          startLocationController.text = address;
        }
      } catch (e) {
        print("Failed to get address: $e");
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _loadRecentSearches(); // Refresh searches too
    if (mounted) {
      SnackbarHelper.showSuccess(context, 'Data refreshed successfully!');
    }
  }

  void _performSearch() {
    if (startLocationController.text.isEmpty ||
        destinationController.text.isEmpty) {
      SnackbarHelper.showWarning(
        context,
        'Please enter both start location and destination',
      );
      return;
    }

    final String from = startLocationController.text;
    final String to = destinationController.text;

    // Save search
    _searchHistoryService.addSearch(from, to).then((_) {
      _loadRecentSearches();
    });

    // Navigate to SearchResults screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResults(
          startLocation: from,
          destination: to,
          query: '$from to $to',
        ),
      ),
    ).then((_) {
      // Reset loading state when returning
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = false;
        });
        _loadRecentSearches(); // Refresh in case anything changed
      }
    });
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks.first;
      return "${place.locality}, ${place.country}";
    } catch (e) {
      return "${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xFF00897B),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),
                      const SizedBox(height: 30),
                      buildSearchSection(
                        context,
                        startLocationController,
                        destinationController,
                        onSearch: _performSearch,
                      ),
                      const SizedBox(height: 30),
                      if (isLoading)
                        Column(
                          children: [
                            const Text(
                              'Popular Destinations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    const DestinationCardSkeleton(),
                              ),
                            ),
                          ],
                        )
                      else if (hasError)
                        EmptyState(
                          icon: Icons.error_outline,
                          title: 'Oops! Something went wrong',
                          message:
                              'We couldn\'t load the destinations. Please try again.',
                          buttonText: 'Retry',
                          onButtonPressed: _loadInitialData,
                        )
                      else if (showEmptyState)
                        EmptyState(
                          icon: Icons.explore_off,
                          title: 'No Destinations Found',
                          message:
                              'Start exploring by searching for your dream destination!',
                          buttonText: 'Explore Now',
                          onButtonPressed: () {
                            SnackbarHelper.showInfo(
                              context,
                              'Opening explore page...',
                            );
                          },
                        )
                      else
                        Column(
                          children: [
                            buildPopularDestinations(),
                            const SizedBox(height: 30),
                            buildQuickActions(context),
                            const SizedBox(height: 30),
                            buildRecentSearches(
                              _recentSearches,
                              _clearAllSearches,
                              _deleteSearch,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const FullScreenLoader(message: 'Loading...'),
        ],
      ),
    );
  }
}
