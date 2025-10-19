import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';

class SearchResults extends StatefulWidget {
  final String? query;
  final String? startLocation;
  final String? destination;

  const SearchResults({
    Key? key,
    this.query,
    this.startLocation,
    this.destination,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late TextEditingController _searchController;
  String selectedFilter = 'All';
  String selectedSort = 'Recommended';
  bool _isLoading = false;

  final List<String> filters = [
    'All',
    'Flights',
    'Hotels',
    'Packages',
    'Activities'
  ];

  final List<String> sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Duration'
  ];

  final List<Map<String, dynamic>> searchResults = [
    {
      'type': 'Flight',
      'title': 'Direct Flight to Paris',
      'airline': 'Air France',
      'departure': '10:30 AM',
      'arrival': '2:45 PM',
      'duration': '4h 15m',
      'price': '\$450',
      'rating': '4.8',
      'icon': '✈️',
    },
    {
      'type': 'Hotel',
      'title': 'The Ritz Paris',
      'location': 'Paris, France',
      'stars': 5,
      'amenities': 'Free WiFi, Pool, Spa',
      'price': '\$350/night',
      'rating': '4.9',
      'icon': '🏨',
    },
    {
      'type': 'Package',
      'title': 'Paris Romantic Getaway',
      'duration': '5 Days, 4 Nights',
      'includes': 'Flight + Hotel + Tours',
      'price': '\$1,200',
      'rating': '4.7',
      'icon': '📦',
    },
    {
      'type': 'Activity',
      'title': 'Eiffel Tower Skip-the-Line',
      'duration': '2 hours',
      'availability': 'Daily',
      'price': '\$45',
      'rating': '4.8',
      'icon': '🗼',
    },
    {
      'type': 'Flight',
      'title': 'Economy Flight to Paris',
      'airline': 'Emirates',
      'departure': '6:00 PM',
      'arrival': '10:30 PM',
      'duration': '4h 30m',
      'price': '\$380',
      'rating': '4.6',
      'icon': '✈️',
    },
    {
      'type': 'Hotel',
      'title': 'Hotel Le Bristol',
      'location': 'Paris, France',
      'stars': 5,
      'amenities': 'Restaurant, Bar, Gym',
      'price': '\$420/night',
      'rating': '4.8',
      'icon': '🏨',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query ?? '');
    _loadResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshResults() async {
    await _loadResults();
    if (mounted) {
      SnackbarHelper.showSuccess(context, 'Results refreshed!');
    }
  }

  List<Map<String, dynamic>> get filteredResults {
    if (selectedFilter == 'All') {
      return searchResults;
    }
    return searchResults
        .where((result) => result['type'] == selectedFilter.replaceAll('s', ''))
        .toList();
  }

  void _bookItem(Map<String, dynamic> item) {
    SnackbarHelper.showInfo(context, 'Booking ${item['title']}...');
  }

  void _saveItem(Map<String, dynamic> item) {
    SnackbarHelper.showSuccess(context, '${item['title']} saved!');
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshResults,
        color: const Color(0xFF00897B),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF00897B),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) => _refreshResults(),
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
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
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor:
                        const Color(0xFF00897B).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF00897B)
                              : Colors.grey[700],
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
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
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFF00897B)),
                ),
              )
                  : filteredResults.isEmpty
                  ? EmptyState(
                icon: Icons.search_off,
                title: 'No Results Found',
                message:
                'Try adjusting your filters or search query',
                buttonText: 'Clear Filters',
                onButtonPressed: () {
                  setState(() {
                    selectedFilter = 'All';
                    _searchController.clear();
                  });
                },
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredResults.length,
                itemBuilder: (context, index) {
                  final result = filteredResults[index];
                  return _buildResultCard(result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    return GestureDetector(
        onTap: () => _bookItem(result),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: Column(
              children: [
                // Header with icon and type
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00897B).withOpacity(0.7),
                        const Color(0xFF26A69A).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        result['icon'],
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                result['type'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00897B),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              result['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 16,
                          ),
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          onPressed: () => _saveItem(result),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      children: [
                  if (result['type'] == 'Flight') ...[
                  _buildDetailRow(
                  Icons.flight_takeoff,
                  'Departure',
                  result['departure'],
                ),
                _buildDetailRow(
                  Icons.flight_land,
                  'Arrival',
                  result['arrival'],
                ),
                _buildDetailRow(
                  Icons.access_time,
                  'Duration',
                  result['duration'],
                ),
              ],
              if (result['type'] == 'Hotel') ...[
          _buildDetailRow(
          Icons.location_on,
          'Location',
          result['location'],
        ),
        _buildDetailRow(
            Icons.hotel,
            'Amenities',
          result['amenities'],
        ),
              ],
                        if (result['type'] == 'Package') ...[
                          _buildDetailRow(
                            Icons.calendar_today,
                            'Duration',
                            result['duration'],
                          ),
                          _buildDetailRow(
                            Icons.check_circle,
                            'Includes',
                            result['includes'],
                          ),
                        ],
                        if (result['type'] == 'Activity') ...[
                          _buildDetailRow(
                            Icons.access_time,
                            'Duration',
                            result['duration'],
                          ),
                          _buildDetailRow(
                            Icons.event_available,
                            'Availability',
                            result['availability'],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  result['rating'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              result['price'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _bookItem(result),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00897B),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
              ],
          ),
        ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }
}