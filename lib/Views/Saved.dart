import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  String selectedCategory = 'All';
  bool _isLoading = false;

  final List<String> categories = ['All', 'Hotels', 'Restaurants', 'Activities', 'Places'];

  final List<Map<String, dynamic>> savedItems = [
    {
      'title': 'Eiffel Tower',
      'location': 'Paris, France',
      'category': 'Places',
      'image': '🗼',
      'rating': '4.8',
      'description': 'Iconic iron lattice tower',
      'savedDate': '2024-10-15',
    },
    {
      'title': 'The Ritz Hotel',
      'location': 'Paris, France',
      'category': 'Hotels',
      'image': '🏨',
      'rating': '4.9',
      'description': 'Luxury 5-star hotel',
      'savedDate': '2024-10-10',
    },
    {
      'title': 'L\'Astrance Restaurant',
      'location': 'Paris, France',
      'category': 'Restaurants',
      'image': '🍽️',
      'rating': '4.7',
      'description': 'Michelin-starred dining',
      'savedDate': '2024-10-12',
    },
    {
      'title': 'Senso-ji Temple',
      'location': 'Tokyo, Japan',
      'category': 'Places',
      'image': '⛩️',
      'rating': '4.6',
      'description': 'Historic Buddhist temple',
      'savedDate': '2024-10-08',
    },
    {
      'title': 'Kayaking Adventure',
      'location': 'Bali, Indonesia',
      'category': 'Activities',
      'image': '🚣',
      'rating': '4.8',
      'description': 'Thrilling water sports',
      'savedDate': '2024-10-05',
    },
    {
      'title': 'Burj Khalifa',
      'location': 'Dubai, UAE',
      'category': 'Places',
      'image': '🏙️',
      'rating': '4.7',
      'description': 'Tallest building in the world',
      'savedDate': '2024-09-28',
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'All') {
      return savedItems;
    }
    return savedItems
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  Future<void> _refreshSavedItems() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Saved items refreshed!');
    }
  }

  void _removeSavedItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove "${item['title']}" from saved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarHelper.showSuccess(
                context,
                '${item['title']} removed from saved',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _viewItemDetails(Map<String, dynamic> item) {
    SnackbarHelper.showInfo(context, 'Viewing ${item['title']}');
  }

  void _shareItem(Map<String, dynamic> item) {
    SnackbarHelper.showInfo(context, 'Sharing ${item['title']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSavedItems,
        color: const Color(0xFF00897B),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
            if (filteredItems.isEmpty)
              SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.bookmark_outline,
                  title: 'No Saved Items',
                  message:
                      'Save places, hotels, and activities to your favorites!',
                  buttonText: 'Start Exploring',
                  onButtonPressed: () {
                    SnackbarHelper.showInfo(context, 'Opening explore page...');
                  },
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filteredItems[index];
                      return GestureDetector(
                        onTap: () => _viewItemDetails(item),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00897B).withOpacity(0.7),
                                      const Color(0xFF26A69A).withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    item['image'],
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['title'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF263238),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
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
                                                  size: 12,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  item['rating'],
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              item['location'],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00897B)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['category'],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF00897B),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _shareItem(item),
                                            icon: const Icon(Icons.share),
                                            iconSize: 16,
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                            padding: EdgeInsets.zero,
                                            color: const Color(0xFF00897B),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _removeSavedItem(item),
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            iconSize: 16,
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredItems.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}