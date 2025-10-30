import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';

class Activities extends StatefulWidget {
  final String? cityName;

  const Activities({Key? key, this.cityName}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isLoading = false;
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> _filteredActivities = [];

  final List<String> _categories = [
    'All',
    'Adventure',
    'Culture',
    'Food',
    'Sports',
    'Relaxation',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadActivities() {
    setState(() {
      _isLoading = true;
    });

    // Simulating API call with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _activities = [
          {
            'id': '1',
            'name': 'Scuba Diving Experience',
            'category': 'Adventure',
            'image': '🤿',
            'location': 'Coral Bay',
            'duration': '3 hours',
            'price': '\$85',
            'rating': 4.9,
            'reviews': 342,
            'description':
                'Explore the underwater world with professional instructors. Perfect for beginners and experienced divers.',
            'difficulty': 'Moderate',
            'isSaved': false,
          },
          {
            'id': '2',
            'name': 'City Food Tour',
            'category': 'Food',
            'image': '🍜',
            'location': 'Downtown',
            'duration': '4 hours',
            'price': '\$65',
            'rating': 4.8,
            'reviews': 523,
            'description':
                'Taste authentic local cuisine at hidden gems. Guided tour includes 8 food stops.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
          {
            'id': '3',
            'name': 'Mountain Hiking Trek',
            'category': 'Adventure',
            'image': '⛰️',
            'location': 'Highland Peaks',
            'duration': '6 hours',
            'price': '\$95',
            'rating': 4.7,
            'reviews': 287,
            'description':
                'Challenging hike with breathtaking views. Includes guide, equipment, and lunch.',
            'difficulty': 'Hard',
            'isSaved': false,
          },
          {
            'id': '4',
            'name': 'Traditional Cooking Class',
            'category': 'Culture',
            'image': '👨‍🍳',
            'location': 'Culinary Center',
            'duration': '3 hours',
            'price': '\$75',
            'rating': 4.9,
            'reviews': 456,
            'description':
                'Learn to cook traditional dishes from expert chefs. Take home recipes and skills.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
          {
            'id': '5',
            'name': 'Surfing Lessons',
            'category': 'Sports',
            'image': '🏄',
            'location': 'Sunset Beach',
            'duration': '2 hours',
            'price': '\$55',
            'rating': 4.6,
            'reviews': 198,
            'description':
                'Catch your first wave with professional surf instructors. All equipment included.',
            'difficulty': 'Moderate',
            'isSaved': false,
          },
          {
            'id': '6',
            'name': 'Spa & Wellness Retreat',
            'category': 'Relaxation',
            'image': '💆',
            'location': 'Tranquil Gardens',
            'duration': '2.5 hours',
            'price': '\$120',
            'rating': 4.9,
            'reviews': 612,
            'description':
                'Full body massage, sauna, and relaxation therapy. Pure bliss and rejuvenation.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
          {
            'id': '7',
            'name': 'Live Music Concert',
            'category': 'Entertainment',
            'image': '🎸',
            'location': 'City Arena',
            'duration': '3 hours',
            'price': '\$45',
            'rating': 4.7,
            'reviews': 892,
            'description':
                'Enjoy live performances from local and international artists. Premium seating available.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
          {
            'id': '8',
            'name': 'Zip-lining Adventure',
            'category': 'Adventure',
            'image': '🪂',
            'location': 'Adventure Park',
            'duration': '2 hours',
            'price': '\$70',
            'rating': 4.8,
            'reviews': 267,
            'description':
                'Soar through the treetops on thrilling zip-line courses. Safety equipment included.',
            'difficulty': 'Moderate',
            'isSaved': false,
          },
          {
            'id': '9',
            'name': 'Cultural Museum Tour',
            'category': 'Culture',
            'image': '🏛️',
            'location': 'Heritage District',
            'duration': '2.5 hours',
            'price': '\$35',
            'rating': 4.5,
            'reviews': 423,
            'description':
                'Discover local history and art with expert guides. Interactive exhibits included.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
          {
            'id': '10',
            'name': 'Yoga on the Beach',
            'category': 'Relaxation',
            'image': '🧘',
            'location': 'Paradise Beach',
            'duration': '1.5 hours',
            'price': '\$40',
            'rating': 4.8,
            'reviews': 334,
            'description':
                'Morning yoga session with ocean views. All levels welcome. Mat provided.',
            'difficulty': 'Easy',
            'isSaved': false,
          },
        ];
        _filteredActivities = List.from(_activities);
        _isLoading = false;
      });
    });
  }

  void _filterActivities() {
    setState(() {
      _filteredActivities = _activities.where((activity) {
        final matchesSearch = activity['name']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            activity['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleSave(String activityId) {
    setState(() {
      final index =
          _filteredActivities.indexWhere((a) => a['id'] == activityId);
      if (index != -1) {
        _filteredActivities[index]['isSaved'] =
            !_filteredActivities[index]['isSaved'];
        SnackbarHelper.showSuccess(
          context,
          _filteredActivities[index]['isSaved']
              ? 'Activity saved!'
              : 'Activity removed from saved',
        );
      }
    });
  }

  void _bookActivity(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingSheet(activity),
    );
  }

  Widget _buildBookingSheet(Map<String, dynamic> activity) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
          Padding(
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
                          activity['image'],
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
                            activity['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['location'],
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
                _buildInfoRow(Icons.access_time, 'Duration', activity['duration']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.signal_cellular_alt, 'Difficulty',
                    activity['difficulty']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.attach_money, 'Price', activity['price']),
                const SizedBox(height: 25),
                const Text(
                  'Select Date & Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF00897B)),
                      const SizedBox(width: 10),
                      Text(
                        'Tomorrow, 10:00 AM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Number of Participants',
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
                        '2',
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
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      SnackbarHelper.showSuccess(
                        context,
                        '${activity['name']} booked successfully!',
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
                      'Confirm Booking',
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
          widget.cityName != null ? '${widget.cityName} Activities' : 'Activities',
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
            child: _filteredActivities.isEmpty
                ? const EmptyState(
                    icon: Icons.local_activity_outlined,
                    title: 'No Activities Found',
                    message: 'Try adjusting your filters',
                  )
                : _buildActivitiesList(),
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
        onChanged: (value) => _filterActivities(),
        decoration: InputDecoration(
          hintText: 'Search activities...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF00897B)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterActivities();
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
                  _filterActivities();
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

  Widget _buildActivitiesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = _filteredActivities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          SnackbarHelper.showInfo(context, 'Activity details coming soon!');
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
                      activity['image'],
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
                        activity['isSaved']
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: const Color(0xFF00897B),
                      ),
                      onPressed: () => _toggleSave(activity['id']),
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
                      activity['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
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
                  Text(
                    activity['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        activity['location'],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        activity['duration'],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activity['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(activity['difficulty'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          activity['difficulty'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getDifficultyColor(activity['difficulty']),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        activity['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${activity['reviews']} reviews)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        activity['price'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _bookActivity(activity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}