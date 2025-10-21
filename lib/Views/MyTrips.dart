import 'package:flutter/material.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({super.key});

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
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trips refreshed successfully!')),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _showMessage('${trip['title']} deleted');
            },
            child: const Text('Delete'),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: Colors.teal.shade600,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTrips,
        color: Colors.teal.shade600,
        child: trips.isEmpty ? _buildEmptyState() : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return _buildTripCard(trip);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMessage('Creating new trip...'),
        backgroundColor: Colors.teal.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.luggage, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Trips Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start planning your adventure by creating a new trip!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showMessage('Create new trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
              ),
              child: const Text('Create Trip'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showMessage('Viewing ${trip['title']}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal.shade600,
                    Colors.teal.shade400,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(trip['image'], style: const TextStyle(fontSize: 60)),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        trip['destination'],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildInfoColumn('Duration', '${trip['days']} days'),
                      _buildInfoColumn('Activities', '${trip['activities']} planned'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${trip['startDate']} - ${trip['endDate']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showMessage('Edit ${trip['title']}'),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal.shade600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _deleteTrip(trip),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
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
              color:Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
