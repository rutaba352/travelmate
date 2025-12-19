import 'package:flutter/material.dart';
import 'package:travelmate/Services/SavedItemsService.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Views/MainNavigation.dart';

import 'package:travelmate/Views/HotelDetails.dart';
import 'package:travelmate/Views/SpotDetails.dart';
import 'package:travelmate/Views/Activities.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  String selectedCategory = 'All';
  final SavedItemsService _savedItemsService = SavedItemsService();

  final List<String> categories = [
    'All',
    'Hotels',
    'Flights',
    'Activities',
    'Places',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _savedItemsService.getSavedItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00897B)),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final allItems = snapshot.data ?? [];
          final filteredItems = _filterItems(allItems);

          if (allItems.isEmpty) {
            return EmptyState(
              icon: Icons.bookmark_border,
              title: 'No Saved Places',
              message: 'Your favorite destinations will appear here',
              buttonText: 'Start Exploring',
              onButtonPressed: () {
                MainNavigation.switchTab(context, 1); // Switch to Explore Tab
              },
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
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
                            '${filteredItems.length} saved items',
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
                                backgroundColor: Colors.white,
                                selectedColor: const Color(
                                  0xFF00897B,
                                ).withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF00897B)
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                checkmarkColor: const Color(0xFF00897B),
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items in $selectedCategory',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = filteredItems[index];
                      return Dismissible(
                        key: Key(item['itemId'] ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.red[700]),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Remove Item'),
                              content: Text(
                                'Remove "${item['title']}" from saved?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                  ),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          await _savedItemsService.removeItem(item['itemId']);
                          if (context.mounted) {
                            SnackbarHelper.showSuccess(context, 'Item removed');
                          }
                        },
                        child: _buildSavedItemCard(item),
                      );
                    }, childCount: filteredItems.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    if (selectedCategory == 'All') return items;
    return items.where((item) => item['category'] == selectedCategory).toList();
  }

  Widget _buildSavedItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _viewItemDetails(item),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: _getItemImage(item),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    _getCategoryEmoji(item['category']),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Explicit Actions
                        Row(
                          children: [
                            if (item['rating'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['rating'].toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            InkWell(
                              onTap: () => _confirmDelete(item),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['location'] ?? 'Unknown Location',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['category'] ?? 'General',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF00897B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          item['price'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
  }

  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsave Item'),
        content: Text('Remove "${item['title']}" from saved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _savedItemsService.removeItem(item['itemId']);
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Item unsaved');
      }
    }
  }

  ImageProvider _getItemImage(Map<String, dynamic> item) {
    if (item['image'] != null && item['image'].toString().startsWith('http')) {
      return NetworkImage(item['image']);
    }
    // Asset or Emoji check logic
    if (item['image'] != null &&
        item['image'].toString().startsWith('assets/')) {
      return AssetImage(item['image']);
    }
    return const AssetImage('assets/images/placeholder.jpg');
  }

  String _getCategoryEmoji(String? category) {
    switch (category) {
      case 'Hotels':
        return '🏨';
      case 'Flights':
        return '✈️';
      case 'Activities':
        return '🎯';
      case 'Places':
        return '🌍';
      case 'Restaurants':
        return '🍽️';
      default:
        return '📍';
    }
  }

  void _viewItemDetails(Map<String, dynamic> item) {
    final category = item['category']?.toString() ?? '';

    if (category == 'Hotels') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HotelDetails(hotelData: item)),
      );
    } else if (category == 'Places') {
      // Places (Cities) should go to Activities list, just like from Explore
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Activities(
            cityName: item['name'],
            cityId: item['name']?.toString().toLowerCase(),
          ),
        ),
      );
    } else if (category == 'Activities') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpotDetails(spotData: item)),
      );
    } else {
      // For items that don't have dedicated pages yet (Flights, etc)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(item['title'] ?? 'Item Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: $category'),
              const SizedBox(height: 8),
              if (item['location'] != null)
                Text('Location: ${item['location']}'),
              const SizedBox(height: 8),
              if (item['price'] != null) Text('Price: ${item['price']}'),
              const SizedBox(height: 16),
              const Text(
                'Full details not available for this item type yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
          ],
        ),
      );
    }
  }
}
