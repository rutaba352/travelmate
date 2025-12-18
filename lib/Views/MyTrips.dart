import 'package:flutter/material.dart';
import 'package:travelmate/Services/SavedItemsService.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Views/MainNavigation.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({super.key});

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  final SavedItemsService _service = SavedItemsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.getBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trips = snapshot.data ?? [];

          if (trips.isEmpty) {
            return EmptyState(
              icon: Icons.luggage,
              title: 'No Trips Yet',
              message:
                  'Start planning your adventure by booking flights or hotels!',
              buttonText: 'Plan a Trip',
              onButtonPressed: () {
                // Return to main screen then switch to Explore
                Navigator.popUntil(context, (route) => route.isFirst);
                MainNavigation.switchTab(context, 1); // Switch to Explore
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return _buildTripCard(trip);
            },
          );
        },
      ),
    );
  }

  void _deleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip'),
        content: Text('Are you sure you want to cancel "${trip['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await _service.removeBooking(trip['itemId']);
              if (success) {
                if (context.mounted)
                  SnackbarHelper.showSuccess(context, 'Trip cancelled');
              } else {
                if (context.mounted)
                  SnackbarHelper.showError(context, 'Failed to cancel trip');
              }
            },
            child: const Text('Cancel Trip'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Planning':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () =>
            SnackbarHelper.showInfo(context, 'Viewing ${trip['title']}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF00897B), const Color(0xFF26A69A)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      _getEmojiForCategory(trip['category']),
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(trip['status']),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        trip['status'] ?? 'Upcoming',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip['title'] ?? 'Unknown Trip',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip['location'] ?? 'Unknown Destination',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoColumn('Date', trip['startDate'] ?? 'TBD'),
                      _buildInfoColumn('Price', trip['price'] ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => SnackbarHelper.showInfo(
                          context,
                          'Edit not available',
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF00897B),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _deleteTrip(trip),
                        icon: const Icon(Icons.delete),
                        label: const Text('Cancel'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
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

  String _getEmojiForCategory(String? category) {
    if (category == 'Flights') return '✈️';
    if (category == 'Hotels') return '🏨';
    if (category == 'Activities') return '🎯';
    if (category == 'Places') return '🌍';
    if (category == 'Restaurants') return '🍽️';
    return '✈️';
  }

  Widget _buildInfoColumn(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00897B),
            ),
          ),
        ],
      ),
    );
  }
}
