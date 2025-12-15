import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import '../Services/location/destination_api.dart';

/// Explore Screen - Main destination browsing interface
/// Features: Search with autocomplete, category filtering, grid display
class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // ============ STATE MANAGEMENT ============
  // Controllers manage user input
  late TextEditingController _searchController;

  // Current selected category for filtering
  String _selectedCategory = 'All';

  // Debounce timer prevents too many API calls while typing
  Timer? _debounceTimer;

  // Search suggestion system
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;
  OverlayEntry? _suggestionOverlay;
  final LayerLink _layerLink = LayerLink(); // Links overlay to search field

  // ============ CONSTANTS ============
  static const Color _primaryColor = Color(0xFF00897B);
  static const Color _accentColor = Color(0xFF26A69A);
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  // Category list for filtering
  final List<String> _categories = [
    'All', 'Adventure', 'Beach', 'Culture', 'Food', 'Nature', 'Historical'
  ];

  List<Map<String, dynamic>> _apiDestinations = [];
  bool _isSearchingAPI = false;

  // ============ DESTINATION DATA ============
  // Complete list of destinations (Pakistani + International)
  final List<Map<String, dynamic>> _destinations = [
    // ===== PAKISTANI DESTINATIONS =====
    {
      'name': 'Hunza Valley',
      'country': 'Pakistan',
      'image': 'assets/images/hunza.jpg', // Mountain valley with lakes
      'category': 'Nature',
      'rating': '4.9',
      'description': 'Paradise on Earth with stunning mountains',
      'price': 'PKR 25,000',
      'highlights': 'Attabad Lake, Passu Cones, Altit Fort',
    },
    {
      'name': 'Skardu',
      'country': 'Pakistan',
      'image': 'assets/images/skardu.jpg', // Shangrila Resort & mountains
      'category': 'Adventure',
      'rating': '4.8',
      'description': 'Gateway to K2 and mighty peaks',
      'price': 'PKR 30,000',
      'highlights': 'Shangrila Resort, Deosai Plains, Shigar Fort',
    },
    {
      'name': 'Swat Valley',
      'country': 'Pakistan',
      'image': 'assets/images/swat.jpg', // Green valleys and river
      'category': 'Nature',
      'rating': '4.7',
      'description': 'Switzerland of Pakistan',
      'price': 'PKR 20,000',
      'highlights': 'Kalam Valley, Mahodand Lake, Malam Jabba',
    },
    {
      'name': 'Fairy Meadows',
      'country': 'Pakistan',
      'image': 'assets/images/fairy_meadows.jpg', // Nanga Parbat view
      'category': 'Adventure',
      'rating': '4.9',
      'description': 'Base of Nanga Parbat - Killer Mountain',
      'price': 'PKR 35,000',
      'highlights': 'Nanga Parbat view, Camping, Trekking',
    },
    {
      'name': 'Naran Kaghan',
      'country': 'Pakistan',
      'image': 'assets/images/naran.jpg', // Saif-ul-Malook Lake
      'category': 'Nature',
      'rating': '4.6',
      'description': 'Beautiful valley with pristine lakes',
      'price': 'PKR 18,000',
      'highlights': 'Saif-ul-Malook, Babusar Top, Lulusar Lake',
    },
    {
      'name': 'Lahore',
      'country': 'Pakistan',
      'image': 'assets/images/lahore.jpg', // Badshahi Mosque
      'category': 'Culture',
      'rating': '4.7',
      'description': 'Heart of Pakistan - Cultural capital',
      'price': 'PKR 15,000',
      'highlights': 'Badshahi Mosque, Lahore Fort, Food Street',
    },
    {
      'name': 'Murree',
      'country': 'Pakistan',
      'image': 'assets/images/murree.jpg', // Mall Road with pine trees
      'category': 'Nature',
      'rating': '4.4',
      'description': 'Popular hill station near Islamabad',
      'price': 'PKR 12,000',
      'highlights': 'Mall Road, Patriata, Kashmir Point',
    },
    {
      'name': 'Mohenjo-daro',
      'country': 'Pakistan',
      'image': 'assets/images/mohenjo_daro.jpg', // Ancient ruins
      'category': 'Historical',
      'rating': '4.6',
      'description': 'Ancient Indus Valley Civilization',
      'price': 'PKR 10,000',
      'highlights': 'UNESCO Site, Ancient ruins, Museum',
    },
    {
      'name': 'Karachi',
      'country': 'Pakistan',
      'image': 'assets/images/karachi.jpg', // Clifton Beach
      'category': 'Beach',
      'rating': '4.3',
      'description': 'City of lights by the Arabian Sea',
      'price': 'PKR 20,000',
      'highlights': 'Clifton Beach, Mohatta Palace, Food scene',
    },
    {
      'name': 'Neelum Valley',
      'country': 'Pakistan',
      'image': 'assets/images/neelum.jpg', // River and mountains
      'category': 'Nature',
      'rating': '4.8',
      'description': 'Emerald valley in Kashmir',
      'price': 'PKR 28,000',
      'highlights': 'Keran, Sharda, Kel, Ratti Gali Lake',
    },

    // ===== INTERNATIONAL DESTINATIONS =====
    {
      'name': 'Maldives',
      'country': 'Island Nation',
      'image': 'assets/images/maldives.jpg', // Overwater bungalows
      'category': 'Beach',
      'rating': '4.9',
      'description': 'Tropical paradise with crystal waters',
      'price': 'PKR 450,000',
      'highlights': 'Overwater villas, Diving, Marine life',
    },
    {
      'name': 'Dubai',
      'country': 'UAE',
      'image': 'assets/images/dubai.jpg', // Burj Khalifa
      'category': 'Adventure',
      'rating': '4.7',
      'description': 'Luxury desert metropolis',
      'price': 'PKR 180,000',
      'highlights': 'Burj Khalifa, Desert Safari, Shopping',
    },
    {
      'name': 'Istanbul',
      'country': 'Turkey',
      'image': 'assets/images/istanbul.jpg', // Blue Mosque
      'category': 'Culture',
      'rating': '4.8',
      'description': 'Where East meets West',
      'price': 'PKR 200,000',
      'highlights': 'Hagia Sophia, Grand Bazaar, Bosphorus',
    },
    {
      'name': 'Bangkok',
      'country': 'Thailand',
      'image': 'assets/images/bangkok.jpg', // Grand Palace
      'category': 'Food',
      'rating': '4.6',
      'description': 'Street food capital of the world',
      'price': 'PKR 150,000',
      'highlights': 'Street food, Temples, Night markets',
    },
    {
      'name': 'Bali',
      'country': 'Indonesia',
      'image': 'assets/images/bali.jpg', // Rice terraces
      'category': 'Beach',
      'rating': '4.8',
      'description': 'Island of Gods',
      'price': 'PKR 220,000',
      'highlights': 'Beaches, Temples, Rice terraces',
    },
    {
      'name': 'Paris',
      'country': 'France',
      'image': 'assets/images/paris.jpg', // Eiffel Tower
      'category': 'Culture',
      'rating': '4.8',
      'description': 'City of lights and romance',
      'price': 'PKR 550,000',
      'highlights': 'Eiffel Tower, Louvre, Seine River',
    },
    {
      'name': 'Swiss Alps',
      'country': 'Switzerland',
      'image': 'assets/images/swiss_alps.jpg', // Snow mountains
      'category': 'Nature',
      'rating': '4.9',
      'description': 'Alpine paradise',
      'price': 'PKR 600,000',
      'highlights': 'Skiing, Mountain trains, Lakes',
    },
    {
      'name': 'Santorini',
      'country': 'Greece',
      'image': 'assets/images/santorini.jpg', // White buildings
      'category': 'Beach',
      'rating': '4.9',
      'description': 'Most romantic sunset destination',
      'price': 'PKR 400,000',
      'highlights': 'White architecture, Sunsets, Beaches',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _removeSuggestionOverlay();
    super.dispose();
  }


  Map<String, dynamic>? _findLocalDestination(String apiPlaceName) {
    // Clean the API name (remove country/region part)
    final cleanedName = apiPlaceName.split(',')[0].trim();

    // Search in your hardcoded destinations
    for (var dest in _destinations) {
      final destName = dest['name'].toString().toLowerCase();

      // Check multiple matching strategies
      if (destName.contains(cleanedName.toLowerCase()) ||
          apiPlaceName.toLowerCase().contains(destName) ||
          cleanedName.toLowerCase().contains(destName)) {
        return dest;
      }
    }

    return null;
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _removeSuggestionOverlay();
      setState(() {
        _apiDestinations = [];
      });
      return;
    }

    if (query.length < 2) {
      _removeSuggestionOverlay();
      return;
    }

    _debounceTimer = Timer(_debounceDelay, () {
      _fetchAPIDestinations(query); // New method
    });
  }

  Future<void> _fetchAPIDestinations(String query) async {
    setState(() => _isSearchingAPI = true);

    final suggestions = await DestinationApi.getPlaceSuggestions(query);

    if (mounted) {
      // Convert API suggestions to destination format
      _apiDestinations = suggestions.map((placeName) {
        // First check if it exists in hardcoded data
        final localDest = _findLocalDestination(placeName);
        if (localDest != null) return localDest;

        // Otherwise create fallback
        return _createFallbackDestination(placeName);
      }).toList();

      setState(() {
        _isLoadingSuggestions = false;
        _isSearchingAPI = false;
      });
    }
  }

  /// Fetches city suggestions from API based on search query
  Future<void> _fetchSuggestions(String query) async {
    setState(() => _isLoadingSuggestions = true);

    final suggestions = await DestinationApi.getPlaceSuggestions(query);

    if (mounted) {
      setState(() {
        _suggestions = suggestions;
        _isLoadingSuggestions = false;
      });

      if (suggestions.isNotEmpty) {
        _showSuggestionOverlay();
      } else {
        _removeSuggestionOverlay();
      }
    }
  }

  Map<String, dynamic> _createFallbackDestination(String apiPlaceName) {
    final parts = apiPlaceName.split(',');
    final city = parts[0].trim();
    final country = parts.length > 1 ? parts[1].trim() : 'Unknown';

    // Determine category
    String determineCategory() {
      final lowerName = apiPlaceName.toLowerCase();
      if (lowerName.contains('beach') || lowerName.contains('island') || lowerName.contains('sea')) return 'Beach';
      if (lowerName.contains('mountain') || lowerName.contains('valley') || lowerName.contains('lake')) return 'Nature';
      if (lowerName.contains('museum') || lowerName.contains('temple') || lowerName.contains('mosque')) return 'Culture';
      if (lowerName.contains('park') || lowerName.contains('forest') || lowerName.contains('garden')) return 'Nature';
      if (lowerName.contains('food') || lowerName.contains('restaurant')) return 'Food';
      if (lowerName.contains('fort') || lowerName.contains('castle') || lowerName.contains('ancient')) return 'Historical';
      return 'Culture';
    }

    // Get appropriate image based on category
    String getCategoryImage(String category) {
      switch(category.toLowerCase()) {
        case 'beach': return 'assets/images/maldives.jpg';
        case 'nature': return 'assets/images/hunza.jpg';
        case 'adventure': return 'assets/images/skardu.jpg';
        case 'culture': return 'assets/images/lahore.jpg';
        case 'historical': return 'assets/images/mohenjo_daro.jpg';
        case 'food': return 'assets/images/bangkok.jpg';
        default: return 'assets/images/placeholder.jpg';
      }
    }

    final category = determineCategory();

    return {
      'name': city,
      'country': country,
      'image': getCategoryImage(category),
      'category': category,
      'rating': (4.0 + Random().nextDouble()).toStringAsFixed(1),
      'description': 'Explore the beautiful $city in $country. Experience local culture, attractions, and cuisine.',
      'price': 'PKR ${(15000 + Random().nextInt(300000)).toStringAsFixed(0)}',
      'highlights': _generateHighlights(category),
      'isFallback': true,
    };
  }

// Helper for dynamic highlights
  String _generateHighlights(String category) {
    switch(category) {
      case 'Beach': return 'Beaches, Water sports, Sunsets';
      case 'Nature': return 'Scenic views, Hiking, Photography';
      case 'Adventure': return 'Trekking, Camping, Activities';
      case 'Culture': return 'Local culture, Food, Markets';
      case 'Historical': return 'Ancient sites, Museums, Heritage';
      case 'Food': return 'Local cuisine, Street food, Restaurants';
      default: return 'Attractions, Culture, Sightseeing';
    }
  }

  Widget _buildCityPlaceholder(String cityName, String category) {
    // Color scheme based on category
    final Map<String, Color> categoryColors = {
      'Beach': Color(0xFF4FC3F7), // Light Blue
      'Nature': Color(0xFF81C784), // Green
      'Adventure': Color(0xFF7986CB), // Indigo
      'Culture': Color(0xFFBA68C8), // Purple
      'Historical': Color(0xFF4DB6AC), // Teal
      'Food': Color(0xFFFF8A65), // Orange
    };

    final color = categoryColors[category] ?? Color(0xFF00897B);
    final initial = cityName.isNotEmpty ? cityName[0].toUpperCase() : 'T';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              initial,
              style: TextStyle(
                fontSize: 42,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              cityName.length > 12 ? '${cityName.substring(0, 10)}...' : cityName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Handles when user taps a suggestion
  void _onSuggestionTap(String placeName) {
    _searchController.text = placeName;
    _removeSuggestionOverlay();

    // Try to find in hardcoded data
    final localDest = _findLocalDestination(placeName);

    if (localDest != null) {
      // Found in hardcoded data - show your rich destination
      _bookDestination(localDest);
    } else {
      // Not in hardcoded data - show basic info
      SnackbarHelper.showInfo(
          context,
          'Showing basic info for $placeName\n(Full details coming soon!)'
      );
      // You can navigate to a generic detail screen here
    }
  }

  /// Clears search and resets UI
  void _clearSearch() {
    _searchController.clear();
    _removeSuggestionOverlay();
    setState(() {
      _suggestions = [];
      _apiDestinations = [];
    });
  }

  // ============ OVERLAY MANAGEMENT ============
  // Overlay = Floating widget positioned relative to another widget

  /// Shows search suggestions in a floating overlay below search bar
  void _showSuggestionOverlay() {
    _removeSuggestionOverlay();

    _suggestionOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink, // Links to search field position
          showWhenUnlinked: false,
          offset: const Offset(0, 48), // 48px below search field
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isLoadingSuggestions
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    onTap: () => _onSuggestionTap(_suggestions[index]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_suggestionOverlay!);
  }

  /// Removes the suggestion overlay from screen
  void _removeSuggestionOverlay() {
    _suggestionOverlay?.remove();
    _suggestionOverlay = null;
  }

  // ============ FILTERING LOGIC ============

  /// Returns filtered destinations based on category and search
  List<Map<String, dynamic>> get _filteredDestinations {
    // If searching and we have API results, show them
    if (_searchController.text.isNotEmpty && _apiDestinations.isNotEmpty) {
      // Filter by category if needed
      if (_selectedCategory != 'All') {
        return _apiDestinations
            .where((dest) => dest['category'] == _selectedCategory)
            .toList();
      }
      return _apiDestinations;
    }

    // Otherwise show hardcoded destinations with original filtering
    var filtered = _destinations;
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((dest) => dest['category'] == _selectedCategory)
          .toList();
    }

    // Original search filtering for hardcoded data
    if (_searchController.text.isNotEmpty) {
      final searchText = _searchController.text.toLowerCase();
      final cityName = searchText.split(',')[0].trim();

      filtered = filtered.where((dest) {
        final name = dest['name'].toString().toLowerCase();
        final country = dest['country'].toString().toLowerCase();
        return name.contains(cityName) ||
            country.contains(cityName) ||
            name.contains(searchText) ||
            country.contains(searchText);
      }).toList();
    }

    return filtered;
  }
  // ============ USER ACTIONS ============

  /// Pull-to-refresh action
  Future<void> _refreshDestinations() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      SnackbarHelper.showSuccess(context, 'Destinations refreshed!');
    }
  }

  /// Booking action when destination card is tapped
  void _bookDestination(Map<String, dynamic> destination) {
    SnackbarHelper.showInfo(context, 'Booking ${destination['name']}...');
    // Navigate to booking screen here
  }

  /// Save to favorites action
  void _saveDestination(Map<String, dynamic> destination) {
    SnackbarHelper.showSuccess(
      context,
      '${destination['name']} saved to favorites!',
    );
    // Save to database/favorites list here
  }

  // ============ UI BUILDING METHODS ============

  /// Builds the search bar with autocomplete
  Widget _buildSearchBar() {
    return CompositedTransformTarget(
      link: _layerLink, // Target for overlay positioning
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        onTapOutside: (_) => _removeSuggestionOverlay(),
        decoration: InputDecoration(
          hintText: 'Search destinations...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearchingAPI
              ? const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// Builds horizontal scrolling category filter chips
  Widget _buildCategoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263238),
          ),
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
                  onSelected: (_) => setState(() => _selectedCategory = category),
                  backgroundColor: Colors.grey[100],
                  selectedColor: _primaryColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? _primaryColor : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

  /// Shows search results count
  Widget _buildResultsCount() {
    if (_searchController.text.isEmpty) return const SizedBox.shrink();

    final count = _filteredDestinations.length;

    String source = '';
    if (_apiDestinations.isNotEmpty && _searchController.text.isNotEmpty) {
      source = ' (from API)';
    } else if (_searchController.text.isNotEmpty && count > 0) {
      source = ' (from local)';
    }
    return Text(
      'Showing $count result${count == 1 ? '' : 's'}$source for "${_searchController.text}"',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// Builds individual destination card
  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return GestureDetector(
      onTap: () => _bookDestination(destination),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with gradient overlay
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: destination['isFallback'] == true
                    ? _buildCityPlaceholder(destination['name'], destination['category'])
                    : ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    destination['image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildCityPlaceholder(destination['name'], destination['category']);
                    },
                  ),
                ),
              ),
            ),
            // Details section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destination['country'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
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
                      if (destination['isFallback'] == true)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Text(
                            'API',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
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

  /// Empty state when no destinations match filters
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
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try a different search term'
                  : 'No destinations in this category',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // ============ MAIN BUILD METHOD ============

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
            // Top section with search and filters
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
                    _buildResultsCount(),
                  ],
                ),
              ),
            ),
            // Grid of destinations or empty state
            _filteredDestinations.isEmpty
                ? _buildEmptyState()
                : SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  childAspectRatio: 0.8, // Card height/width ratio
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildDestinationCard(
                    _filteredDestinations[index],
                  ),
                  childCount: _filteredDestinations.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}