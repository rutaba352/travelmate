import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';

class TouristSpotsList extends StatefulWidget {
  final String? cityName;
  final String? countryName;

  const TouristSpotsList({
    Key? key,
    this.cityName,
    this.countryName,
  }) : super(key: key);

  @override
  State<TouristSpotsList> createState() => _TouristSpotsListState();
}

class _TouristSpotsListState extends State<TouristSpotsList> {
  late TextEditingController _searchController;
  String selectedCategory = 'All';
  bool _isLoading = false;
  String _sortBy = 'Popular';

  final List<String> categories = [
    'All',
    'Historical',
    'Nature',
    'Adventure',
    'Cultural',
    'Religious',
  ];

  final List<String> sortOptions = ['Popular', 'Rating', 'Distance', 'Price'];

  final List<Map<String, dynamic>> touristSpots = [
    {
      'name': 'Eiffel Tower',
      'location': 'Paris, France',
      'image': '🗼',
      'category': 'Historical',
      'rating': '4.8',
      'reviews': 12500,
      'description': 'Iconic iron lattice tower and symbol of Paris',
      'entryFee': '\$25',
      'distance': '2.5 km',
      'openTime': '9:00 AM - 11:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Louvre Museum',
      'location': 'Paris, France',
      'image': '🎨',
      'category': 'Cultural',
      'rating': '4.9',
      'reviews': 18700,
      'description': 'World\'s largest art museum and historic monument',
      'entryFee': '\$20',
      'distance': '3.2 km',
      'openTime': '9:00 AM - 6:00 PM',
      'isSaved': true,
    },
    {
      'name': 'Notre-Dame Cathedral',
      'location': 'Paris, France',
      'image': '⛪',
      'category': 'Religious',
      'rating': '4.7',
      'reviews': 9800,
      'description': 'Medieval Catholic cathedral with Gothic architecture',
      'entryFee': 'Free',
      'distance': '3.8 km',
      'openTime': '8:00 AM - 6:45 PM',
      'isSaved': false,
    },
    {
      'name': 'Arc de Triomphe',
      'location': 'Paris, France',
      'image': '🏛️',
      'category': 'Historical',
      'rating': '4.6',
      'reviews': 8500,
      'description': 'Monumental arch honoring French military victories',
      'entryFee': '\$13',
      'distance': '4.1 km',
      'openTime': '10:00 AM - 10:30 PM',
      'isSaved': false,
    },
    {
      'name': 'Seine River Cruise',
      'location': 'Paris, France',
      'image': '🚢',
      'category': 'Adventure',
      'rating': '4.8',
      'reviews': 15200,
      'description': 'Scenic boat tour along the Seine River',
      'entryFee': '\$18',
      'distance': '2.8 km',
      'openTime': '10:00 AM - 10:00 PM',
      'isSaved': true,
    },
    {
      'name': 'Luxembourg Gardens',
      'location': 'Paris, France',
      'image': '🌳',
      'category': 'Nature',
      'rating': '4.7',
      'reviews': 6900,
      'description': 'Beautiful public park with gardens and fountains',
      'entryFee': 'Free',
      'distance': '4.5 km',
      'openTime': '7:30 AM - 9:30 PM',
      'isSaved': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadSpots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSpots() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredSpots {
    List<Map<String, dynamic>> filtered = touristSpots;

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((spot) => spot['category'] == selectedCategory)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((spot) =>
              spot['name']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              spot['description']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> _refreshSpots() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Tourist spots refreshed!');
    }
  }

  void _toggleSave(int index) {
    setState(() {
      touristSpots[index]['isSaved'] = !touristSpots[index]['isSaved'];
    });
    SnackbarHelper.showSuccess(
      context,
      touristSpots[index]['isSaved']
          ? '${touristSpots[index]['name']} saved!'
          : '${touristSpots[index]['name']} removed from saved',
    );
  }

  void _viewSpotDetails(Map<String, dynamic> spot) {
    SnackbarHelper.showInfo(context, 'Opening ${spot['name']} details');
    // TODO: Navigate to SpotDetails screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SpotDetails(spotData: spot)));
  }

  void _showSortDialog() {
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
                  leading: Radio<String>(
                    value: option,
                    groupValue: _sortBy,
                    activeColor: const Color(0xFF00897B),
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      Navigator.pop(context);
                      SnackbarHelper.showSuccess(
                        context,
                        'Sorted by $option',
                      );
                    },
                  ),
                  onTap: () {
                    setState(() => _sortBy = option);
                    Navigator.pop(context);
                    SnackbarHelper.showSuccess(context, 'Sorted by $option');
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
        title: Text(widget.cityName ?? 'Tourist Spots'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Opening map view');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSpots,
        color: const Color(0xFF00897B),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF00897B),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search tourist spots...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263238),
                        ),
                      ),
                      Text(
                        '${filteredSpots.length} spots found',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            backgroundColor: Colors.grey[100],
                            selectedColor:
                                const Color(0xFF00897B).withOpacity(0.2),
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
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: const ShimmerLoader(
                            width: double.infinity,
                            height: 140,
                          ),
                        );
                      },
                    )
                  : filteredSpots.isEmpty
                      ? EmptyState(
                          icon: Icons.explore_off,
                          title: 'No Spots Found',
                          message:
                              'Try adjusting your filters or search terms',
                          buttonText: 'Clear Filters',
                          onButtonPressed: () {
                            setState(() {
                              selectedCategory = 'All';
                              _searchController.clear();
                            });
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredSpots.length,
                          itemBuilder: (context, index) {
                            final spot = filteredSpots[index];
                            return GestureDetector(
                              onTap: () => _viewSpotDetails(spot),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 140,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF00897B)
                                                    .withOpacity(0.7),
                                                const Color(0xFF26A69A)
                                                    .withOpacity(0.7),
                                              ],
                                            ),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              spot['image'],
                                              style:
                                                  const TextStyle(fontSize: 60),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF00897B)
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              spot['category'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                              icon: Icon(
                                                spot['isSaved']
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                size: 18,
                                              ),
                                              color: spot['isSaved']
                                                  ? const Color(0xFF00897B)
                                                  : Colors.grey[600],
                                              onPressed: () =>
                                                  _toggleSave(touristSpots
                                                      .indexOf(spot)),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  spot['name'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF263238),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[50],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      spot['rating'],
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            spot['description'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  spot['distance'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                spot['openTime'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.people_outline,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${spot['reviews']} reviews',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                spot['entryFee'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF00897B),
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
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}