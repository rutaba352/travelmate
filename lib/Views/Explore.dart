import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Services/SavedItemsService.dart';
import 'package:travelmate/Services/API/AmadeusApiService.dart';
import 'package:travelmate/Views/Activities.dart';

/// Explore Screen - Main destination browsing interface
/// Features: Search with autocomplete, category filtering, grid display
class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // ============ STATE MANAGEMENT ============
  late TextEditingController _searchController;
  String _selectedCategory = 'All';
  Timer? _debounceTimer;

  // Search suggestion system
  OverlayEntry? _suggestionOverlay;

  static const Color _primaryColor = Color(0xFF00897B);
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  final List<String> _categories = [
    'All',
    'Adventure',
    'Beach',
    'Culture',
    'Food',
    'Nature',
    'Historical',
  ];

  // Dynamic Destinations List (Fetched from API)
  List<Map<String, dynamic>> _destinations = [];
  bool _isLoadingDestinations = false;
  List<Map<String, dynamic>> _apiSearchResults = [];
  bool _isSearchingAPI = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadFeaturedDestinations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _removeSuggestionOverlay();
    super.dispose();
  }

  /// Fetch Featured Destinations from Amadeus API (or Mock)
  Future<void> _loadFeaturedDestinations() async {
    setState(() => _isLoadingDestinations = true);

    // Initial list of cities to fetch as "Featured"
    final featuredCities = [
      'Paris',
      'Dubai',
      'London',
      'New York',
      'Istanbul',
      'Bangkok',
      'Lahore',
      'Karachi',
    ];

    List<Map<String, dynamic>> loadedLocations = [];

    for (var city in featuredCities) {
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
        print('Error loading featured city $city: $e');
      }
    }

    if (mounted) {
      setState(() {
        _destinations = loadedLocations;
        _isLoadingDestinations = false;
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
      'isFallback': false, // Sourced from "API" logic
      'raw': location, // Keep raw data if needed
    };
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _removeSuggestionOverlay();
      setState(() {
        _apiSearchResults = [];
      });
      return;
    }

    if (query.length < 2) {
      _removeSuggestionOverlay();
      return;
    }

    _debounceTimer = Timer(_debounceDelay, () {
      _performApiSearch(query);
    });
  }

  Future<void> _performApiSearch(String query) async {
    setState(() => _isSearchingAPI = true);

    try {
      final results = await AmadeusApiService().searchLocations(query);

      if (mounted) {
        setState(() {
          _apiSearchResults = results
              .map((l) => _decorateLocationData(l))
              .toList();
          _isSearchingAPI = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearchingAPI = false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _apiSearchResults = [];
    });
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
      // Return web URL as fallback since local asset is having bundling issues
      return 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?q=80&w=600&auto=format&fit=crop';
    if (lower.contains('maldives')) return 'assets/images/maldives.jpg';
    if (lower.contains('hunza')) return 'assets/images/hunza.jpg';
    if (lower.contains('skardu')) return 'assets/images/skardu.jpg';
    if (lower.contains('lahore')) return 'assets/images/lahore.jpg';
    if (lower.contains('karachi')) return 'assets/images/karachi.jpg';
    if (lower.contains('istanbul')) return 'assets/images/istanbul.jpg';
    if (lower.contains('bangkok')) return 'assets/images/bangkok.jpg';
    if (lower.contains('new york') || lower.contains('nyc'))
      // Return web URL as fallback
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

  void _removeSuggestionOverlay() {
    _suggestionOverlay?.remove();
    _suggestionOverlay = null;
  }

  // ============ UI LOGIC ============

  List<Map<String, dynamic>> get _displayDestinations {
    // If user is searching, show API results
    if (_searchController.text.isNotEmpty) {
      // Filter API results by category if needed
      if (_selectedCategory != 'All') {
        return _apiSearchResults
            .where((d) => d['category'] == _selectedCategory)
            .toList();
      }
      return _apiSearchResults;
    }

    // Otherwise show Default Featured list
    if (_selectedCategory != 'All') {
      return _destinations
          .where((d) => d['category'] == _selectedCategory)
          .toList();
    }
    return _destinations;
  }

  Future<void> _refreshDestinations() async {
    await _loadFeaturedDestinations();
    if (mounted)
      SnackbarHelper.showSuccess(context, 'Destinations refreshed from API');
  }

  void _bookDestination(Map<String, dynamic> destination) {
    // Navigate to Activities (Booking Flow)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Activities(
          cityName: destination['name'],
          cityId: destination['name'].toString().toLowerCase(),
        ),
      ),
    );
  }

  Future<void> _saveDestination(Map<String, dynamic> destination) async {
    final savedItemsService = SavedItemsService();
    final success = await savedItemsService.saveDestination(destination);

    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(
          context,
          '${destination['name']} saved to favorites!',
        );
      } else {
        SnackbarHelper.showError(context, 'Failed to save.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: _primaryColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDestinations,
        color: _primaryColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildCategoryFilters(),
                    const SizedBox(height: 16),
                    if (_isLoadingDestinations)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: _primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (_displayDestinations.isEmpty && !_isLoadingDestinations)
              _buildEmptyState()
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildDestinationCard(_displayDestinations[index]),
                    childCount: _displayDestinations.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search destinations (e.g. Rome)...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _isSearchingAPI
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _searchController.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Category',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                  backgroundColor: Colors.grey[100],
                  selectedColor: _primaryColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? _primaryColor : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? _primaryColor : Colors.grey[300]!,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return GestureDetector(
      onTap: () => _bookDestination(destination),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: destination['image'].toString().startsWith('http')
                        ? Image.network(
                            destination['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: _primaryColor.withOpacity(0.3),
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: _primaryColor,
                                    ),
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            destination['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: _primaryColor.withOpacity(0.3),
                                  child: Center(
                                    child: Icon(
                                      Icons.location_city,
                                      size: 40,
                                      color: _primaryColor,
                                    ),
                                  ),
                                ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => _saveDestination(destination),
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    destination['country'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            destination['rating'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        destination['price'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No destinations found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
