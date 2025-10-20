import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class RouteDetails extends StatefulWidget {
  const RouteDetails({Key? key}) : super(key: key);

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

  void _editStop(Map<String, dynamic> stop) {
    SnackbarHelper.showInfo(context, 'Edit ${stop['title']}');
  }

  void _deleteStop(Map<String, dynamic> stop) {
    SnackbarHelper.showSuccess(context, '${stop['title']} removed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Share route');
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'View on map');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00897B),
                  const Color(0xFF26A69A),
                ],
              ),
            ),
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
                Text(
                  'Dec 15, 2024 - Dec 22, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
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
                            color: Colors.grey[300],
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
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00897B).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Day ${stop['day']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00897B),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () => _editStop(stop),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red[700],
                                        ),
                                        onPressed: () => _deleteStop(stop),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                stop['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    stop['time'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      stop['location'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
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
                                  color: Colors.grey[700],
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
        onPressed: () {
          SnackbarHelper.showInfo(context, 'Add new activity');
        },
        backgroundColor: const Color(0xFF00897B),
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
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}