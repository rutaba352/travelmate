import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({Key? key}) : super(key: key);

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  bool _isLoading = false;
  final List<Map<String, dynamic>> trips = [
    {
      'title': 'Paris Vacation',
      'destination': 'Paris, France',
      'startDate': 'Dec 15, 2024',
      'endDate': 'Dec 22, 2024',
      'days': 7,
      'image': '🗼',
      'status': 'Upcoming',
      'activities': 8,
    },
    {
      'title': 'Tokyo Adventure',
      'destination': 'Tokyo, Japan',
      'startDate': 'Jan 5, 2025',
      'endDate': 'Jan 18, 2025',
      'days': 13,
      'image': '🗾',
      'status': 'Planning',
      'activities': 12,
    },
    {
      'title': 'Dubai Luxury',
      'destination': 'Dubai, UAE',
      'startDate': 'Nov 1, 2024',
      'endDate': 'Nov 5, 2024',
      'days': 4,
      'image': '🏙️',
      'status': 'Completed',
      'activities': 6,
    },
  ];

  Future<void> _refreshTrips() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Trips refreshed successfully!');
    }
  }

  void _viewTripDetails(Map<String, dynamic> trip) {
    SnackbarHelper.showInfo(context, 'Viewing ${trip['title']}');
  }

  void _editTrip(Map<String, dynamic> trip) {
    SnackbarHelper.showInfo(context, 'Edit ${trip['title']}');
  }

  void _deleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip['title']}"?'),
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
                '${trip['title']} deleted',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTrips,
        color: const Color(0xFF00897B),
        child: trips.isEmpty
            ? EmptyState(
                icon: Icons.luggage,
                title: 'No Trips Yet',
                message: 'Start planning your adventure by creating a new trip!',
                buttonText: 'Create Trip',
                onButtonPressed: () {
                  SnackbarHelper.showInfo(context, 'Create new trip');
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return GestureDetector(
                    onTap: () => _viewTripDetails(trip),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
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
                                    trip['image'],
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
                                      trip['status'],
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
                                  trip['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      trip['destination'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Duration',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${trip['days']} days',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF00897B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Activities',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${trip['activities']} planned',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF00897B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${trip['startDate']} - ${trip['endDate']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _editTrip(trip),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF00897B),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _deleteTrip(trip),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red[700],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SnackbarHelper.showInfo(context, 'Creating new trip...');
        },
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Planning':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  }