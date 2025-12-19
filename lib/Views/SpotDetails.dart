import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Views/MapView.dart';
import 'package:travelmate/Services/BookingService.dart';
import 'package:travelmate/Services/SavedItemsService.dart'; // Added for toggle functionality

class SpotDetails extends StatefulWidget {
  final Map<String, dynamic>? spotData;

  const SpotDetails({Key? key, this.spotData}) : super(key: key);

  @override
  State<SpotDetails> createState() => _SpotDetailsState();
}

class _SpotDetailsState extends State<SpotDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;

  // Uses placeholders if specific images list isn't provided (likely not in main data)
  final List<String> images = ['📸', '🌅', '🌃', '🎨', '🗼'];

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Sarah Johnson',
      'avatar': '👩',
      'rating': 5.0,
      'date': 'Oct 10, 2024',
      'comment': 'Absolutely stunning! A must-visit. The view is breathtaking.',
    },
    {
      'name': 'Michael Chen',
      'avatar': '👨',
      'rating': 4.5,
      'date': 'Oct 5, 2024',
      'comment': 'Great experience. Book tickets in advance to skip lines.',
    },
  ];

  final List<Map<String, dynamic>> nearbySpots = [
    {
      'name': 'Nearby Attraction 1',
      'distance': '1.2 km',
      'image': '🎨',
      'rating': '4.5',
    },
    {
      'name': 'Nearby Attraction 2',
      'distance': '0.5 km',
      'image': '☕',
      'rating': '4.2',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isSaved = widget.spotData?['isSaved'] ?? false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSave() async {
    // Optimistic UI update
    setState(() {
      _isSaved = !_isSaved;
    });

    if (widget.spotData == null) return;

    if (_isSaved) {
      await SavedItemsService().saveActivity(widget.spotData!);
      if (mounted) SnackbarHelper.showSuccess(context, 'Saved to favorites!');
    } else {
      // If we have an ID, we can remove it. But itemID structure might vary.
      // For now, simple toggle logic. Proper unsave needs ItemID which might not be passed purely perfectly here if coming effectively from Explore without being saved first.
      // However, for "Unsaving" from Saved screen, we assume it's handling itself. This is mostly for visual toggle.
      if (widget.spotData?['itemId'] != null) {
        await SavedItemsService().removeItem(widget.spotData!['itemId']);
        if (mounted)
          SnackbarHelper.showSuccess(context, 'Removed from favorites');
      }
    }
  }

  Future<void> _bookTicket() async {
    DateTime? selectedDate = DateTime.now();
    int tickets = 1;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Book Tickets',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Date',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate!,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF00897B),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF00897B),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tickets',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (tickets > 1) {
                                  setModalState(() => tickets--);
                                }
                              },
                              color: const Color(0xFF00897B),
                            ),
                            Text(
                              '$tickets',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setModalState(() => tickets++);
                              },
                              color: const Color(0xFF00897B),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final bookingData = Map<String, dynamic>.from(
                            widget.spotData ?? {},
                          );

                          // Normalize data for MyTrips
                          bookingData['startDate'] =
                              "${selectedDate!.day} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year}";
                          bookingData['tickets'] = tickets;
                          bookingData['category'] = 'Activities'; // Important
                          bookingData['status'] = 'Upcoming';

                          // Ensure title logic matches Service
                          if (bookingData['name'] == null &&
                              bookingData['title'] != null) {
                            bookingData['name'] = bookingData['title'];
                          } else if (bookingData['name'] == null) {
                            bookingData['name'] = 'Unknown Activity';
                          }

                          // Use BookingService
                          try {
                            final success = await BookingService()
                                .createBooking(bookingData);
                            if (success) {
                              if (context.mounted)
                                SnackbarHelper.showSuccess(
                                  context,
                                  'Activity booked successfully!',
                                );
                            } else {
                              if (context.mounted)
                                SnackbarHelper.showError(
                                  context,
                                  'Failed to book activity.',
                                );
                            }
                          } catch (e) {
                            if (context.mounted)
                              SnackbarHelper.showError(
                                context,
                                'Service Error: $e',
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
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
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _shareSpot() {
    SnackbarHelper.showInfo(
      context,
      'Sharing ${widget.spotData?['name'] ?? 'Spot'}...',
    );
  }

  void _getDirections() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapView(tripTitle: widget.spotData?['name'] ?? 'Location'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.spotData?['name'] ?? widget.spotData?['title'] ?? 'Details';
    final location = widget.spotData?['location'] ?? 'Unknown Location';
    final rating = widget.spotData?['rating'] ?? '4.5';
    final price = widget.spotData?['price'] ?? 'Price N/A';
    final description =
        widget.spotData?['description'] ?? 'Discover amazing experiences here.';
    final image = widget.spotData?['image'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF00897B),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF00897B)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF00897B),
                  ),
                ),
                onPressed: _toggleSave,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Color(0xFF00897B)),
                ),
                onPressed: _shareSpot,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00897B).withOpacity(0.7),
                          const Color(0xFF26A69A).withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: _buildHeaderImage(image),
                  ),
                  // Removed the horizontal list of emojis for now to simplify and ensure dynamic data focus
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.access_time,
                          'Duration',
                          widget.spotData?['duration'] ?? 'Flexible',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.attach_money,
                          'Entry Fee',
                          price.toString().startsWith('PKR')
                              ? price
                              : 'PKR $price',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.directions_walk,
                          'Distance',
                          '2.5 km', // Placeholder
                        ),
                      ),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.people,
                          'Reviews',
                          widget.spotData?['reviews']?.toString() ?? '100+',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF00897B),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: const Color(0xFF00897B),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Nearby'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 350,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAboutTab(description),
                        _buildReviewsTab(),
                        _buildNearbyTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: _getDirections,
              icon: const Icon(Icons.directions),
              label: const Text('Directions'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00897B),
                side: const BorderSide(color: Color(0xFF00897B)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _bookTicket,
                icon: const Icon(Icons.confirmation_number),
                label: const Text('Book Ticket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(dynamic imageSource) {
    if (imageSource != null && imageSource.toString().startsWith('http')) {
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.white),
        ),
      );
    }
    if (imageSource != null && imageSource.toString().startsWith('assets/')) {
      return Image.asset(
        imageSource,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => const Center(
          child: Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    }
    // Emoji fallback or text
    return Center(
      child: Text(imageSource ?? '📸', style: const TextStyle(fontSize: 100)),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00897B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00897B), size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(String description) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This Place',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Highlights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 12),
          _buildHighlightItem('🌟', 'Spectacular views'),
          _buildHighlightItem('📸', 'Perfect photo opportunities'),
          _buildHighlightItem('🏛️', 'Historical significance'),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF00897B).withOpacity(0.2),
                      child: Text(
                        review['avatar'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            review['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            review['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review['comment'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearbyTab() {
    return ListView.builder(
      itemCount: nearbySpots.length,
      itemBuilder: (context, index) {
        final spot = nearbySpots[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
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
                  spot['image'],
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            title: Text(
              spot['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(spot['distance']),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    spot['rating'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpotDetails(spotData: spot),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
