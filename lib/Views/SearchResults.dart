import 'package:flutter/material.dart';
import 'package:travelmate/Services/API/AmadeusApiService.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';
import 'package:travelmate/Services/SavedItemsService.dart';

class SearchResults extends StatefulWidget {
  final String? query;
  final String? startLocation;
  final String? destination;

  const SearchResults({
    super.key,
    this.query,
    this.startLocation,
    this.destination,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late TextEditingController _searchController;
  final AmadeusApiService _apiService = AmadeusApiService();

  String selectedFilter = 'All';
  String selectedSort = 'Recommended';
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // API Results
  List<Map<String, dynamic>> _flights = [];
  List<Map<String, dynamic>> _hotels = [];
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> _packages = [];

  // Location codes
  String? _originCode;
  String? _destinationCode;
  double? _destLatitude;
  double? _destLongitude;

  final List<String> filters = [
    'All',
    'Flights',
    'Hotels',
    'Packages',
    'Activities',
  ];

  final List<String> sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Duration',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query ?? '');
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Main search function - calls all APIs
  Future<void> _performSearch() async {
    if (widget.startLocation == null || widget.destination == null) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please provide start location and destination';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Step 1: Get location codes
      await _getLocationCodes();

      if (_originCode == null || _destinationCode == null) {
        throw Exception('Could not find location codes');
      }

      // Step 2: Search all types (parallel for speed)
      await Future.wait([
        _searchFlights(),
        _searchHotels(),
        _searchActivities(),
      ]);

      // Step 3: Create packages from flight + hotel combinations
      _createPackages();

      setState(() {
        _isLoading = false;
      });

      if (_flights.isEmpty && _hotels.isEmpty && _activities.isEmpty) {
        SnackbarHelper.showWarning(
          context,
          'No results found. Try different locations or dates.',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Search failed: ${e.toString()}';
      });
      SnackbarHelper.showError(
        context,
        'Failed to fetch results. Please check your API credentials.',
      );
    }
  }

  /// Get IATA codes for cities
  Future<void> _getLocationCodes() async {
    try {
      // Search origin
      final originResults = await _apiService.searchLocations(
        widget.startLocation!,
      );
      if (originResults.isNotEmpty) {
        _originCode = originResults[0]['code'];
      }

      // Search destination
      final destResults = await _apiService.searchLocations(
        widget.destination!,
      );
      if (destResults.isNotEmpty) {
        _destinationCode = destResults[0]['code'];
        // Get coordinates for activities search
        final geo = destResults[0]['geoCode'];
        if (geo != null) {
          _destLatitude = (geo['latitude'] as num).toDouble();
          _destLongitude = (geo['longitude'] as num).toDouble();
        } else {
          _destLatitude = 48.8566;
          _destLongitude = 2.3522;
        }
      }
    } catch (e) {
      throw Exception('Failed to get location codes: $e');
    }
  }

  /// Search Flights
  Future<void> _searchFlights() async {
    try {
      final flights = await _apiService.searchFlights(
        originCode: _originCode!,
        destinationCode: _destinationCode!,
        departureDate: _getSearchDate(),
        adults: 1,
      );
      setState(() {
        _flights = flights;
      });
    } catch (e) {
      print('Flight search error: $e');
      // Don't throw - let other searches continue
    }
  }

  /// Search Hotels
  Future<void> _searchHotels() async {
    try {
      final hotels = await _apiService.searchHotels(
        cityCode: _destinationCode!,
        checkInDate: _getSearchDate(),
        checkOutDate: _getCheckoutDate(),
        adults: 1,
      );
      setState(() {
        _hotels = hotels;
      });
    } catch (e) {
      print('Hotel search error: $e');
    }
  }

  /// Search Activities
  Future<void> _searchActivities() async {
    if (_destLatitude == null || _destLongitude == null) return;

    try {
      final activities = await _apiService.searchActivities(
        latitude: _destLatitude!,
        longitude: _destLongitude!,
        radius: 10,
      );
      setState(() {
        _activities = activities;
      });
    } catch (e) {
      print('Activities search error: $e');
    }
  }

  /// Create package combinations
  void _createPackages() {
    _packages.clear();
    if (_flights.isEmpty || _hotels.isEmpty) return;

    // Create top 3 package combinations
    for (int i = 0; i < _flights.length && i < 3; i++) {
      for (int j = 0; j < _hotels.length && j < 1; j++) {
        _apiService.createPackage(flight: _flights[i], hotel: _hotels[j]).then((
          package,
        ) {
          setState(() {
            _packages.add(package);
          });
        });
      }
    }
  }

  /// Helper: Get search date (tomorrow)
  String _getSearchDate() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
  }

  /// Helper: Get checkout date (5 days from now)
  String _getCheckoutDate() {
    final checkout = DateTime.now().add(const Duration(days: 6));
    return '${checkout.year}-${checkout.month.toString().padLeft(2, '0')}-${checkout.day.toString().padLeft(2, '0')}';
  }

  /// Get filtered results based on selected filter
  List<Map<String, dynamic>> get filteredResults {
    switch (selectedFilter) {
      case 'Flights':
        return _flights;
      case 'Hotels':
        return _hotels;
      case 'Activities':
        return _activities;
      case 'Packages':
        return _packages;
      default: // 'All'
        return [..._flights, ..._hotels, ..._activities, ..._packages];
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
              const SizedBox(height: 20),
              ...sortOptions.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: selectedSort == option
                      ? const Icon(Icons.check, color: Color(0xFF00897B))
                      : null,
                  onTap: () {
                    setState(() => selectedSort = option);
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Sorted by $option');
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _performSearch,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Info Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF00897B).withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.startLocation} → ${widget.destination}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tomorrow • 1 Adult',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (_originCode != null && _destinationCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_originCode → $_destinationCode',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = filter == selectedFilter;

                  // Count results for each filter
                  int count = 0;
                  switch (filter) {
                    case 'Flights':
                      count = _flights.length;
                      break;
                    case 'Hotels':
                      count = _hotels.length;
                      break;
                    case 'Activities':
                      count = _activities.length;
                      break;
                    case 'Packages':
                      count = _packages.length;
                      break;
                    case 'All':
                      count =
                          _flights.length +
                          _hotels.length +
                          _activities.length +
                          _packages.length;
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('$filter ($count)'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: const Color(0xFF00897B).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF00897B)
                            : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF00897B)
                            : Colors.grey[300]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredResults.length} results found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Sort: $selectedSort',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00897B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Results List
          Expanded(child: _buildResultsBody()),
        ],
      ),
    );
  }

  Widget _buildResultsBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00897B)),
            ),
            SizedBox(height: 16),
            Text('Searching flights, hotels & activities...'),
          ],
        ),
      );
    }

    if (_hasError) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Search Error',
        message: _errorMessage,
        buttonText: 'Try Again',
        onButtonPressed: _performSearch,
      );
    }

    if (filteredResults.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No Results Found',
        message: 'Try different locations or adjust your filters',
        buttonText: 'New Search',
        onButtonPressed: () => Navigator.pop(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final result = filteredResults[index];

        // Determine result type
        if (result.containsKey('airline')) {
          return _buildFlightCard(result);
        } else if (result.containsKey('roomType')) {
          return _buildHotelCard(result);
        } else if (result.containsKey('category') &&
            result.containsKey('description')) {
          return _buildActivityCard(result);
        } else if (result.containsKey('type') && result['type'] == 'Package') {
          return _buildPackageCard(result);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.flight, color: Color(0xFF00897B)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${flight['airline'] ?? 'Unknown'} ${flight['flightNumber'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${flight['stops'] ?? 0} stop${(flight['stops'] ?? 0) != 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${flight['price']?['currency'] ?? 'PKR'} ${flight['price']?['total'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                    Text(
                      '${flight['seats'] ?? 0} seats left',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: Colors.grey,
                  onPressed: () => _saveFlight(flight),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(left: 8),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildFlightTimeInfo(
                    flight['departure']['airport'],
                    _formatTime(flight['departure']['time']),
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
                Expanded(
                  child: _buildFlightTimeInfo(
                    flight['arrival']['airport'],
                    _formatTime(flight['arrival']['time']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${flight['duration']}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightTimeInfo(String airport, String time) {
    return Column(
      children: [
        Text(
          airport,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hotel, color: Color(0xFF00897B)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${hotel['rating']} ⭐ • ${hotel['roomType']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${hotel['price']?['currency'] ?? 'PKR'} ${hotel['price']?['perNight'] ?? 'N/A'}/night',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                    Text(
                      'Total: ${hotel['price']?['currency'] ?? 'PKR'} ${hotel['price']?['total'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.grey,
                      onPressed: () => _saveHotel(hotel),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _bookItem(hotel, 'hotel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_activity,
                    color: Color(0xFF00897B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        activity['category'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              activity['description'],
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${activity['price']?['currency'] ?? 'PKR'} ${activity['price']?['amount'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00897B),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.grey,
                      onPressed: () => _saveActivity(activity),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _bookItem(activity, 'activity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [const Color(0xFF00897B).withOpacity(0.05), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_offer,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'SAVE ${package['savings'] ?? '0%'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PACKAGE DEAL',
                    style: TextStyle(
                      color: Color(0xFF00897B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '✈️ Flight + 🏨 Hotel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                package['duration'] ?? 'Duration N/A',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Regular Price',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${package['price']?['currency'] ?? 'PKR'} ${package['price']?['total']?.toStringAsFixed(0) ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Package Price',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${package['price']?['currency'] ?? 'PKR'} ${package['price']?['finalPrice']?.toStringAsFixed(0) ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      SnackbarHelper.showSuccess(context, 'Booking package...'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Book Package',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ HELPERS ============

  Future<void> _saveFlight(Map<String, dynamic> flight) async {
    final success = await SavedItemsService().saveFlight(flight);
    if (mounted) _showSaveMessage(success, 'Flight saved');
  }

  Future<void> _saveHotel(Map<String, dynamic> hotel) async {
    final success = await SavedItemsService().saveHotel(hotel);
    if (mounted) _showSaveMessage(success, 'Hotel saved');
  }

  Future<void> _saveActivity(Map<String, dynamic> activity) async {
    final success = await SavedItemsService().saveActivity(activity);
    if (mounted) _showSaveMessage(success, 'Activity saved');
  }

  Future<void> _bookItem(Map<String, dynamic> item, String type) async {
    bool success = false;
    if (type == 'flight') {
      success = await SavedItemsService().bookFlight(item);
    } else if (type == 'hotel') {
      success = await SavedItemsService().bookHotel(item);
    } else if (type == 'activity') {
      success = await SavedItemsService().bookActivity(item);
    }

    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(context, '$type booked! Check My Trips.');
      } else {
        SnackbarHelper.showError(context, 'Failed to book $type');
      }
    }
  }

  void _showSaveMessage(bool success, String message) {
    if (success) {
      SnackbarHelper.showSuccess(context, message);
    } else {
      SnackbarHelper.showError(context, 'Failed to save');
    }
  }

  String _formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
