import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late TextEditingController _searchController;
  String selectedCategory = 'All';
  bool _isLoading = false;

  final List<String> categories = [
    'All',
    'Adventure',
    'Beach',
    'Culture',
    'Food',
    'Nature'
  ];

  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Paris',
      'country': 'France',
      'image': '🗼',
      'category': 'Culture',
      'rating': '4.8',
      'description': 'City of lights and romance',
      'price': '\$1,200',
    },
    {
      'name': 'Tokyo',
      'country': 'Japan',
      'image': '🗾',
      'category': 'Culture',
      'rating': '4.9',
      'description': 'Modern meets tradition',
      'price': '\$1,500',
    },
    {
      'name': 'Bali',
      'country': 'Indonesia',
      'image': '🏝️',
      'category': 'Beach',
      'rating': '4.8',
      'description': 'Tropical paradise',
      'price': '\$800',
    },
    {
      'name': 'Dubai',
      'country': 'UAE',
      'image': '🏙️',
      'category': 'Adventure',
      'rating': '4.7',
      'description': 'Luxury desert city',
      'price': '\$1,300',
    },
    {
      'name': 'Switzerland',
      'country': 'Europe',
      'image': '⛰️',
      'category': 'Nature',
      'rating': '4.9',
      'description': 'Alpine mountain beauty',
      'price': '\$1,600',
    },
    {
      'name': 'Bangkok',
      'country': 'Thailand',
      'image': '🏯',
      'category': 'Food',
      'rating': '4.6',
      'description': 'Vibrant food scene',
      'price': '\$600',
    },
    {
      'name': 'Iceland',
      'country': 'Nordic',
      'image': '❄️',
      'category': 'Nature',
      'rating': '4.8',
      'description': 'Land of ice and fire',
      'price': '\$1,400',
    },
    {
      'name': 'Cancun',
      'country': 'Mexico',
      'image': '🏖️',
      'category': 'Beach',
      'rating': '4.7',
      'description': 'Caribbean beaches',
      'price': '\$900',
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
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredDestinations {
    List<Map<String, dynamic>> filtered = destinations;

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((dest) => dest['category'] == selectedCategory)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((dest) =>
              dest['name']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              dest['country']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> _refreshDestinations() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Destinations refreshed!');
    }
  }

  void _bookDestination(Map<String, dynamic> destination) {
    SnackbarHelper.showInfo(
      context,
      'Booking ${destination['name']}...',
    );
  }

  void _saveDestination(Map<String, dynamic> destination) {
    SnackbarHelper.showSuccess(
      context,
      '${destination['name']} saved to favorites!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDestinations,
        color: const Color(0xFF00897B),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search destinations...',
                        prefixIcon: const Icon(Icons.search),
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
                    const SizedBox(height: 20),
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
            ),
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
                  (context, index) {
                    final destination = filteredDestinations[index];
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
                            Expanded(
                              child: Container(
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
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        destination['image'],
                                        style: const TextStyle(fontSize: 50),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.favorite_border,
                                            size: 16,
                                          ),
                                          color: Colors.red,
                                          onPressed: () =>
                                              _saveDestination(destination),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF263238),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    destination['country'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.amber,
                                          ),
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
                                          fontSize: 12,
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
                  childCount: filteredDestinations.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}