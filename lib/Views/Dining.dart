import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';

class Dining extends StatefulWidget {
  final String? cityName;

  const Dining({Key? key, this.cityName}) : super(key: key);

  @override
  State<Dining> createState() => _DiningState();
}

class _DiningState extends State<Dining> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';
  bool _isLoading = false;
  List<Map<String, dynamic>> _restaurants = [];
  List<Map<String, dynamic>> _filteredRestaurants = [];

  // final List<String> _categories = [
  //   'All',
  //   'Pakistani',
  //   'French',
  //   'Japanese',
  //   'Thai',
  //   'Italian',
  //   'Turkish',
  //   'Indonesian',
  //   'Arabic',
  // ];

  final List<String> _locations = [
    'All',
    'Lahore',
    'Karachi',
    'Paris',
    'Tokyo',
    'Bangkok',
    'Dubai',
    'Istanbul',
    'Bali',
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

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _restaurants = [
          // Pakistani Restaurants
          {
            'id': '1',
            'name': 'Cuckoo\'s Den',
            'category': 'Pakistani',
            'location': 'Lahore',
            'country': 'Pakistan',
            'image': 'assets/images/cuckoos_ den.jpeg',
            'cuisine': 'Traditional Pakistani',
            'priceRange': 'PKR 2,000',
            'rating': 4.8,
            'reviews': 1250,
            'description': 'Historic restaurant in the heart of Old Lahore with rooftop dining and traditional Pakistani cuisine',
            'features': ['Rooftop', 'Traditional Music', 'Historical Setting'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '2',
            'name': 'Bundu Khan',
            'category': 'Pakistani',
            'location': 'Karachi',
            'country': 'Pakistan',
            'image': 'assets/images/bundu_khan.jpeg',
            'cuisine': 'BBQ & Pakistani',
            'priceRange': 'PKR 1,500',
            'rating': 4.7,
            'reviews': 2100,
            'description': 'Famous for authentic Pakistani BBQ and traditional dishes. Family-friendly atmosphere',
            'features': ['BBQ Specialist', 'Family Dining', 'Takeout'],
            'deliveryAvailable': true,
            'isSaved': false,
          },
          {
            'id': '3',
            'name': 'Andaaz Restaurant',
            'category': 'Pakistani',
            'location': 'Lahore',
            'country': 'Pakistan',
            'image': 'assets/images/andaaz.jpeg',
            'cuisine': 'Pakistani Fine Dining',
            'priceRange': 'PKR 3,500',
            'rating': 4.9,
            'reviews': 890,
            'description': 'Upscale Pakistani dining with modern presentation and traditional flavors',
            'features': ['Fine Dining', 'Private Rooms', 'Valet Parking'],
            'deliveryAvailable': false,
            'isSaved': false,
          },

          // Paris Restaurants
          {
            'id': '4',
            'name': 'Le Jules Verne',
            'category': 'French',
            'location': 'Paris',
            'country': 'France',
            'image': 'assets/images/le_julis_verne.jpeg',
            'cuisine': 'French Haute Cuisine',
            'priceRange': '\$150',
            'rating': 4.9,
            'reviews': 3200,
            'description': 'Michelin-starred restaurant in the Eiffel Tower with stunning views and exquisite French cuisine',
            'features': ['Michelin Star', 'Eiffel Tower View', 'Dress Code'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '5',
            'name': 'Café de Flore',
            'category': 'French',
            'location': 'Paris',
            'country': 'France',
            'image': 'assets/images/cafe_de_flore.jpeg',
            'cuisine': 'French Café',
            'priceRange': '\$40',
            'rating': 4.6,
            'reviews': 5600,
            'description': 'Historic Parisian café serving classic French breakfast, coffee, and light meals',
            'features': ['Historic', 'Outdoor Seating', 'Coffee Specialist'],
            'deliveryAvailable': false,
            'isSaved': false,
          },

          // Tokyo Restaurants
          {
            'id': '6',
            'name': 'Sukiyabashi Jiro',
            'category': 'Japanese',
            'location': 'Tokyo',
            'country': 'Japan',
            'image': 'assets/images/sukiyabashi_jiro.jpeg',
            'cuisine': 'Sushi Omakase',
            'priceRange': '\$300',
            'rating': 5.0,
            'reviews': 1800,
            'description': 'World-famous 3-Michelin-star sushi restaurant. Reservation required months in advance',
            'features': ['3 Michelin Stars', 'Omakase Only', 'Master Chef'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '7',
            'name': 'Ichiran Ramen',
            'category': 'Japanese',
            'location': 'Tokyo',
            'country': 'Japan',
            'image': 'assets/images/ichiran_ramen.jpeg',
            'cuisine': 'Tonkotsu Ramen',
            'priceRange': '\$12',
            'rating': 4.7,
            'reviews': 8900,
            'description': 'Famous ramen chain with private booths and customizable tonkotsu ramen',
            'features': ['Solo Dining Booths', 'Open 24/7', 'Fast Service'],
            'deliveryAvailable': false,
            'isSaved': false,
          },

          // Bangkok Restaurants
          {
            'id': '8',
            'name': 'Jay Fai',
            'category': 'Thai',
            'location': 'Bangkok',
            'country': 'Thailand',
            'image': 'assets/images/jay_fai.jpeg',
            'cuisine': 'Thai Street Food',
            'priceRange': '\$25',
            'rating': 4.8,
            'reviews': 4300,
            'description': 'Michelin-starred street food. Famous for crab omelette and drunken noodles',
            'features': ['Michelin Star', 'Street Food', 'Long Queues'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '9',
            'name': 'Nahm Restaurant',
            'category': 'Thai',
            'location': 'Bangkok',
            'country': 'Thailand',
            'image': 'assets/images/nahm.jpeg',
            'cuisine': 'Royal Thai Cuisine',
            'priceRange': '\$80',
            'rating': 4.9,
            'reviews': 2100,
            'description': 'Upscale Thai restaurant with traditional royal recipes and modern presentation',
            'features': ['Fine Dining', 'Traditional Recipes', 'Wine Pairing'],
            'deliveryAvailable': false,
            'isSaved': false,
          },

          // Dubai Restaurants
          {
            'id': '10',
            'name': 'Al Mahara',
            'category': 'Arabic',
            'location': 'Dubai',
            'country': 'UAE',
            'image': 'assets/images/al_mahara.jpeg',
            'cuisine': 'Seafood & Arabic',
            'priceRange': '\$200',
            'rating': 4.9,
            'reviews': 1900,
            'description': 'Underwater restaurant in Burj Al Arab with floor-to-ceiling aquarium views',
            'features': ['Underwater Dining', 'Luxury', 'Aquarium Views'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '11',
            'name': 'Arabian Tea House',
            'category': 'Arabic',
            'location': 'Dubai',
            'country': 'UAE',
            'image': 'assets/images/arabian_tea_house.jpeg',
            'cuisine': 'Traditional Emirati',
            'priceRange': '\$35',
            'rating': 4.6,
            'reviews': 3400,
            'description': 'Authentic Emirati cuisine in a heritage building with traditional courtyard',
            'features': ['Traditional', 'Courtyard Seating', 'Cultural Experience'],
            'deliveryAvailable': true,
            'isSaved': false,
          },

          // Istanbul Restaurants
          {
            'id': '12',
            'name': 'Mikla Restaurant',
            'category': 'Turkish',
            'location': 'Istanbul',
            'country': 'Turkey',
            'image': 'assets/images/mikla.jpeg',
            'cuisine': 'Modern Turkish',
            'priceRange': '\$90',
            'rating': 4.8,
            'reviews': 2800,
            'description': 'Rooftop restaurant with panoramic views of Istanbul and modern Turkish cuisine',
            'features': ['Rooftop', 'City Views', 'Modern Cuisine'],
            'deliveryAvailable': false,
            'isSaved': false,
          },

          // Bali Restaurants
          {
            'id': '13',
            'name': 'Locavore',
            'category': 'Indonesian',
            'location': 'Bali',
            'country': 'Indonesia',
            'image': 'assets/images/locavore.jpeg',
            'cuisine': 'Modern Indonesian',
            'priceRange': '\$70',
            'rating': 4.9,
            'reviews': 1600,
            'description': 'Award-winning restaurant using local Balinese ingredients with innovative techniques',
            'features': ['Farm to Table', 'Tasting Menu', 'Local Ingredients'],
            'deliveryAvailable': false,
            'isSaved': false,
          },
          {
            'id': '14',
            'name': 'Warung Biah Biah',
            'category': 'Indonesian',
            'location': 'Bali',
            'country': 'Indonesia',
            'image': 'assets/images/warung.jpeg',
            'cuisine': 'Traditional Balinese',
            'priceRange': '\$8',
            'rating': 4.7,
            'reviews': 5200,
            'description': 'Local favorite for authentic Balinese dishes. Best nasi campur on the island',
            'features': ['Local Favorite', 'Budget Friendly', 'Authentic'],
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

        final matchesLocation = _selectedLocation == 'All' ||
            restaurant['location'] == _selectedLocation;

        return matchesSearch && matchesCategory && matchesLocation;
      }).toList();
    });
  }

  void _toggleSave(String restaurantId) {
    setState(() {
      final index = _restaurants.indexWhere((r) => r['id'] == restaurantId);
      if (index != -1) {
        _restaurants[index]['isSaved'] = !_restaurants[index]['isSaved'];
        SnackbarHelper.showSuccess(
          context,
          _restaurants[index]['isSaved']
              ? 'Restaurant saved!'
              : 'Restaurant removed from saved',
        );
      }
    });
    _filterRestaurants();
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
                          child: Image.asset(
                            restaurant['image'], // Use the image path string
                            width: 50,  // Adjust size as needed
                            height: 50,
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
                              '${restaurant['location']}, ${restaurant['country']}',
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
                  _buildInfoRow(Icons.attach_money, 'Average Price',
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
                      hintText: 'Window seat, dietary restrictions, etc.',
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
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
          _buildLocationFilter(),
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

  Widget _buildLocationFilter() {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            'Location: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                final isSelected = location == _selectedLocation;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(location),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedLocation = location;
                        _filterRestaurants();
                      });
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: const Color(0xFF00897B).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF00897B) : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    checkmarkColor: const Color(0xFF00897B),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryFilter() {
  //   return Container(
  //     height: 50,
  //     color: Colors.white,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       itemCount: _categories.length,
  //       itemBuilder: (context, index) {
  //         final category = _categories[index];
  //         final isSelected = category == _selectedCategory;
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 8),
  //           child: FilterChip(
  //             label: Text(category),
  //             selected: isSelected,
  //             onSelected: (selected) {
  //               setState(() {
  //                 _selectedCategory = category;
  //                 _filterRestaurants();
  //               });
  //             },
  //             backgroundColor: Colors.grey[100],
  //             selectedColor: const Color(0xFF00897B).withOpacity(0.2),
  //             labelStyle: TextStyle(
  //               color: isSelected ? const Color(0xFF00897B) : Colors.grey[700],
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //             ),
  //             checkmarkColor: const Color(0xFF00897B),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Image.asset(
                    restaurant['image'],
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant['location']}, ${restaurant['country']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star,
                          size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['rating'].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${restaurant['reviews']} reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    restaurant['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: restaurant['features'].map<Widget>((feature) {
                      return Chip(
                        label: Text(
                          feature,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            SnackbarHelper.showInfo(
                              context,
                              'Menu for ${restaurant['name']}',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00897B),
                            side: const BorderSide(color: Color(0xFF00897B)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_menu, size: 18),
                              SizedBox(width: 8),
                              Text('View Menu'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _makeReservation(restaurant),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00897B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.table_restaurant, size: 18),
                              SizedBox(width: 8),
                              Text('Reserve Table'),
                            ],
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