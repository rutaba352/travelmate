import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class Dining extends StatefulWidget {
  final String? cityName;

  const Dining({Key? key, this.cityName}) : super(key: key);

  @override
  State<Dining> createState() => _DiningState();
}

class _DiningState extends State<Dining> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isLoading = false;
  List<Map<String, dynamic>> _restaurants = [];
  List<Map<String, dynamic>> _filteredRestaurants = [];

  final List<String> _categories = [
    'All',
    'Italian',
    'Chinese',
    'Indian',
    'Fast Food',
    'Seafood',
    'Vegetarian',
    'Desserts',
  ];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRestaurants() {
    setState(() {
      _isLoading = true;
    });

    // Simulating API call with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _restaurants = [
          {
            'id': '1',
            'name': 'Bella Italia Trattoria',
            'category': 'Italian',
            'image': '🍝',
            'location': 'Downtown',
            'cuisine': 'Italian Cuisine',
            'priceRange': '\$\$',
            'rating': 4.8,
            'reviews': 542,
            'description':
                'Authentic Italian pasta and pizza. Family recipes passed down through generations.',
            'features': ['Outdoor Seating', 'Wine Bar', 'Vegetarian Options'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '2',
            'name': 'Dragon Palace',
            'category': 'Chinese',
            'image': '🥢',
            'location': 'Chinatown',
            'cuisine': 'Chinese Cuisine',
            'priceRange': '\$\$',
            'rating': 4.7,
            'reviews': 423,
            'description':
                'Traditional Chinese dishes with modern twist. Dim sum specialties and Peking duck.',
            'features': ['Private Rooms', 'Takeout', 'Parking'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '3',
            'name': 'Spice Garden',
            'category': 'Indian',
            'image': '🍛',
            'location': 'Little India',
            'cuisine': 'Indian Cuisine',
            'priceRange': '\$',
            'rating': 4.9,
            'reviews': 687,
            'description':
                'Aromatic curries and tandoori specialties. Vegan and gluten-free options available.',
            'features': ['Halal', 'Vegan Options', 'Buffet'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '4',
            'name': 'Burger Junction',
            'category': 'Fast Food',
            'image': '🍔',
            'location': 'Shopping Mall',
            'cuisine': 'American Fast Food',
            'priceRange': '\$',
            'rating': 4.5,
            'reviews': 892,
            'description':
                'Gourmet burgers and loaded fries. Quick service with quality ingredients.',
            'features': ['Drive-Thru', 'Kids Menu', 'Late Night'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '5',
            'name': 'Ocean Breeze Seafood',
            'category': 'Seafood',
            'image': '🦞',
            'location': 'Waterfront',
            'cuisine': 'Fresh Seafood',
            'priceRange': '\$\$\$',
            'rating': 4.9,
            'reviews': 356,
            'description':
                'Fresh catch daily. Lobster, crab, and fish prepared to perfection with ocean views.',
            'features': ['Sea View', 'Fresh Catch', 'Wine Selection'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '6',
            'name': 'Green Leaf Cafe',
            'category': 'Vegetarian',
            'image': '🥗',
            'location': 'Health District',
            'cuisine': 'Vegetarian & Vegan',
            'priceRange': '\$\$',
            'rating': 4.8,
            'reviews': 445,
            'description':
                'Plant-based paradise. Organic ingredients, smoothie bowls, and healthy comfort food.',
            'features': ['100% Vegan', 'Organic', 'Smoothies'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '7',
            'name': 'Sweet Moments Patisserie',
            'category': 'Desserts',
            'image': '🍰',
            'location': 'Arts Quarter',
            'cuisine': 'French Pastries',
            'priceRange': '\$\$',
            'rating': 4.9,
            'reviews': 623,
            'description':
                'Exquisite cakes, pastries, and macarons. Perfect for special occasions or sweet cravings.',
            'features': ['Custom Cakes', 'Coffee Bar', 'Bakery'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '8',
            'name': 'Sakura Sushi House',
            'category': 'Japanese',
            'image': '🍣',
            'location': 'Japanese District',
            'cuisine': 'Japanese Sushi',
            'priceRange': '\$\$\$',
            'rating': 4.8,
            'reviews': 512,
            'description':
                'Authentic sushi and sashimi. Master chefs with 20+ years experience.',
            'features': ['Omakase', 'Sake Bar', 'Traditional'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '9',
            'name': 'Taco Fiesta',
            'category': 'Mexican',
            'image': '🌮',
            'location': 'Beach Road',
            'cuisine': 'Mexican Street Food',
            'priceRange': '\$',
            'rating': 4.6,
            'reviews': 734,
            'description':
                'Street-style tacos, burritos, and quesadillas. Spicy salsa bar and margaritas.',
            'features': ['Outdoor Patio', 'Happy Hour', 'Live Music'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '10',
            'name': 'Mediterranean Delight',
            'category': 'Mediterranean',
            'image': '🥙',
            'location': 'Harbor District',
            'cuisine': 'Mediterranean',
            'priceRange': '\$\$',
            'rating': 4.7,
            'reviews': 467,
            'description':
                'Hummus, falafel, and grilled meats. Fresh ingredients from local farms.',
            'features': ['Healthy Options', 'Catering', 'Lunch Specials'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
        ];
        _filteredRestaurants = List.from(_restaurants);
        _isLoading = false;
      });
    });
  }

  void _filterRestaurants() {
    setState(() {
      _filteredRestaurants = _restaurants.where((restaurant) {
        final matchesSearch = restaurant['name']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            restaurant['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleSave(String restaurantId) {
    setState(() {
      final index =
          _filteredRestaurants.indexWhere((r) => r['id'] == restaurantId);
      if (index != -1) {
        _filteredRestaurants[index]['isSaved'] =
            !_filteredRestaurants[index]['isSaved'];
        SnackbarHelper.showSuccess(
          context,
          _filteredRestaurants[index]['isSaved']
              ? 'Restaurant saved!'
              : 'Restaurant removed from saved',
        );
      }
    });
  }

  void _makeReservation(Map<String, dynamic> restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReservationSheet(restaurant),
    );
  }

  Widget _buildReservationSheet(Map<String, dynamic> restaurant) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00897B).withOpacity(0.7),
                              const Color(0xFF26A69A).withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            restaurant['image'],
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant['cuisine'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildInfoRow(
                      Icons.location_on, 'Location', restaurant['location']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.attach_money, 'Price Range',
                      restaurant['priceRange']),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                      Icons.delivery_dining,
                      'Delivery',
                      restaurant['deliveryAvailable']
                          ? 'Available'
                          : 'Dine-in Only'),
                  const SizedBox(height: 25),
                  const Text(
                    'Select Date & Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFF00897B), size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Tomorrow',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color(0xFF00897B), size: 20),
                              const SizedBox(width: 10),
                              Text(
                                '7:00 PM',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Number of Guests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF00897B),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '4',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF00897B),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Special Requests (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Window seat, birthday celebration, etc.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFF00897B)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        SnackbarHelper.showSuccess(
                          context,
                          'Table reserved at ${restaurant['name']}!',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Reservation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00897B)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.cityName != null
              ? '${widget.cityName} Restaurants'
              : 'Restaurants',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Advanced filters coming soon!');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00897B),
              ),
            )
          : Column(
              children: [
                _buildSearchAndFilter(),
                _buildCategoryFilter(),
                Expanded(
                  child: _filteredRestaurants.isEmpty
                      ? const EmptyState(
                          icon: Icons.restaurant_outlined,
                          title: 'No Restaurants Found',
                          message: 'Try adjusting your filters',
                        )
                      : _buildRestaurantsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _filterRestaurants(),
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF00897B)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterRestaurants();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
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
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                  _filterRestaurants();
                });
              },
              backgroundColor: Colors.grey[100],
              selectedColor: const Color(0xFF00897B).withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF00897B) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              checkmarkColor: const Color(0xFF00897B),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = _filteredRestaurants[index];
        return _buildRestaurantCard(restaurant);
      },
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          SnackbarHelper.showInfo(context, 'Restaurant details coming soon!');
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00897B).withOpacity(0.7),
                        const Color(0xFF26A69A).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      restaurant['image'],
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        restaurant['isSaved']
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: const Color(0xFF00897B),
                      ),
                      onPressed: () => _toggleSave(restaurant['id']),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      restaurant['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ),
                ),
                if (restaurant['deliveryAvailable'])
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delivery_dining,
                              size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        restaurant['priceRange'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['location'],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.restaurant_menu,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant['cuisine'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    restaurant['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (restaurant['features'] as List<dynamic>)
                        .take(3)
                        .map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00897B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00897B),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${restaurant['reviews']} reviews)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () => _makeReservation(restaurant),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reserve',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}