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
import 'package:travelmate/Services/API/AmadeusApiService.dart'; // Added
import 'package:travelmate/Views/Activities.dart'; // Added
import 'dart:math'; // Added

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
  List<Map<String, dynamic>> _popularDestinations = []; // Added

  @override
  void initState() {
    super.initState();
    startLocationController = TextEditingController();
    destinationController = TextEditingController();
    _loadInitialData();
    _loadRecentSearches();
    _loadPopularDestinations(); // Added call

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

  Future<void> _loadPopularDestinations() async {
    // Initial list of cities to fetch as "Popular"
    final popularCities = ['Paris', 'Dubai', 'London', 'New York'];

    List<Map<String, dynamic>> loadedLocations = [];

    for (var city in popularCities) {
      try {
        final results = await AmadeusApiService().searchLocations(city);
        if (results.isNotEmpty) {
          // We take the best match (usually the first CITY)
          final bestMatch = results.firstWhere(
            (l) => l['type'] == 'CITY',
            orElse: () => results.first,
          );

          loadedLocations.add(_decorateLocationData(bestMatch));
        }
      } catch (e) {
        print('Error loading popular city $city: $e');
      }
    }

    if (mounted) {
      setState(() {
        _popularDestinations = loadedLocations;
      });
    }
  }

  // Decorate API location data with UI fields (Image, Price, Category)
  Map<String, dynamic> _decorateLocationData(Map<String, dynamic> location) {
    // Use city name if available (common for Airport results like Heathrow -> London)
    final name =
        (location['city'] != null &&
            location['city'].toString().isNotEmpty &&
            location['city'].toString() != location['name'])
        ? location['city']
        : location['name'] ?? 'Unknown';

    final category = _determineCategory(name);

    return {
      'name': name,
      'country':
          location['country'] ??
          location['address']?['countryName'] ??
          'Unknown',
      'image': _getCategoryImage(category, name),
      'category': category,
      'rating': (4.0 + Random().nextDouble()).toStringAsFixed(1),
      'description':
          'Discover the wonders of $name. Experience amazing $category activities.',
      'price': 'PKR ${(20000 + Random().nextInt(100000)).toStringAsFixed(0)}',
      'highlights': _generateHighlights(category),
      'isFallback': false,
      'raw': location,
    };
  }

  String _determineCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('beach') ||
        lower.contains('maldives') ||
        lower.contains('bali'))
      return 'Beach';
    if (lower.contains('island')) return 'Beach';
    if (lower.contains('mountain') ||
        lower.contains('swat') ||
        lower.contains('hunza'))
      return 'Nature';
    if (lower.contains('paris') ||
        lower.contains('rome') ||
        lower.contains('culture'))
      return 'Culture';
    if (lower.contains('dubai') || lower.contains('new york'))
      return 'Adventure';
    if (lower.contains('bangkok') || lower.contains('food')) return 'Food';
    return 'Culture'; // Default
  }

  String _getCategoryImage(String category, String name) {
    // Check specific names first for better mock images
    final lower = name.toLowerCase();
    if (lower.contains('paris')) return 'assets/images/paris.jpg';
    if (lower.contains('dubai')) return 'assets/images/dubai.jpg';
    if (lower.contains('london'))
      return 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?q=80&w=600&auto=format&fit=crop';
    if (lower.contains('maldives')) return 'assets/images/maldives.jpg';
    if (lower.contains('hunza')) return 'assets/images/hunza.jpg';
    if (lower.contains('skardu')) return 'assets/images/skardu.jpg';
    if (lower.contains('lahore')) return 'assets/images/lahore.jpg';
    if (lower.contains('karachi')) return 'assets/images/karachi.jpg';
    if (lower.contains('istanbul')) return 'assets/images/istanbul.jpg';
    if (lower.contains('bangkok')) return 'assets/images/bangkok.jpg';
    if (lower.contains('new york') || lower.contains('nyc'))
      return 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?q=80&w=600&auto=format&fit=crop';

    switch (category.toLowerCase()) {
      case 'beach':
        return 'assets/images/maldives.jpg';
      case 'nature':
        return 'assets/images/hunza.jpg';
      case 'adventure':
        return 'assets/images/skardu.jpg';
      case 'culture':
        return 'assets/images/lahore.jpg';
      case 'historical':
        return 'assets/images/mohenjo_daro.jpg';
      case 'food':
        return 'assets/images/bangkok.jpg';
      default:
        return 'assets/images/placeholder.jpg';
    }
  }

  String _generateHighlights(String category) {
    switch (category) {
      case 'Beach':
        return 'Beaches, Water sports, Sunsets';
      case 'Nature':
        return 'Scenic views, Hiking, Photography';
      case 'Adventure':
        return 'Trekking, Camping, Activities';
      case 'Culture':
        return 'Local culture, Food, Markets';
      case 'Historical':
        return 'Ancient sites, Museums, Heritage';
      case 'Food':
        return 'Local cuisine, Street food, Restaurants';
      default:
        return 'Attractions, Culture, Sightseeing';
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _loadRecentSearches(); // Refresh searches too
    await _loadPopularDestinations(); // Refresh popular destinations
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
                            buildPopularDestinations(_popularDestinations, (
                              destination,
                            ) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Activities(cityName: destination['name']),
                                ),
                              );
                            }),
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
