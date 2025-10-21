import 'package:flutter/material.dart';

class RouteDetails extends StatefulWidget {
  const RouteDetails({super.key});

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {

  final List<Map<String, dynamic>> routeStops = [
    {
      'day': 1,
      'title': 'Arrival & Hotel Check-in',
      'time': '10:00 AM',
      'location': 'Grand Hotel Paris',
      'description': 'Check into hotel and freshen up',
      'icon': Icons.hotel,
      'color': Colors.blue,
    },
    {
      'day': 1,
      'title': 'Eiffel Tower Visit',
      'time': '2:00 PM',
      'location': 'Champ de Mars, Paris',
      'description': 'Visit the iconic Eiffel Tower and enjoy the view',
      'icon': Icons.cell_tower,
      'color': Colors.orange,
    },
    {
      'day': 1,
      'title': 'Seine River Cruise',
      'time': '6:00 PM',
      'location': 'Port de la Bourdonnais',
      'description': 'Evening cruise along the Seine River',
      'icon': Icons.directions_boat,
      'color': Colors.teal,
    },
    {
      'day': 2,
      'title': 'Louvre Museum',
      'time': '9:00 AM',
      'location': 'Rue de Rivoli, Paris',
      'description': 'Explore world-famous art collections',
      'icon': Icons.museum,
      'color': Colors.purple,
    },
    {
      'day': 2,
      'title': 'Lunch at Café',
      'time': '1:00 PM',
      'location': 'Le Marais District',
      'description': 'Try authentic French cuisine',
      'icon': Icons.restaurant,
      'color': Colors.red,
    },
    {
      'day': 2,
      'title': 'Arc de Triomphe',
      'time': '4:00 PM',
      'location': 'Place Charles de Gaulle',
      'description': 'Visit historic monument and climb to top',
      'icon': Icons.location_city,
      'color': Colors.green,
    },
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _editStop(Map<String, dynamic> stop) {
    _showMessage('Edit ${stop['title']}');
  }

  void _deleteStop(Map<String, dynamic> stop) {
    _showMessage('${stop['title']} removed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
        backgroundColor: Colors.teal.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showMessage('Share route'),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showMessage('View on map'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.teal.shade600,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Paris Vacation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dec 15, 2024 - Dec 22, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('7', 'Days'),
                    _buildStatItem('${routeStops.length}', 'Activities'),
                    _buildStatItem('3', 'Cities'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routeStops.length,
              itemBuilder: (context, index) {
                final stop = routeStops[index];
                final isLastItem = index == routeStops.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: stop['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            stop['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        if (!isLastItem)
                          Container(
                            width: 2,
                            height: 80,
                            color: Colors.grey.shade300,
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    color: Colors.teal.shade50,
                                    child: Text(
                                      'Day ${stop['day']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.grey),
                                        onPressed: () => _editStop(stop),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteStop(stop),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                stop['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    stop['time'],
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      stop['location'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stop['description'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMessage('Add new activity'),
        backgroundColor: Colors.teal.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
