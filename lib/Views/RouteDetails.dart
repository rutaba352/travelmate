import 'package:flutter/material.dart';
import 'package:travelmate/Views/HotelList.dart';
import 'package:travelmate/Views/MapView.dart';

class RouteDetails extends StatelessWidget {
  final String tripTitle;

  const RouteDetails({Key? key, required this.tripTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tripTitle,
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
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapView(tripTitle: tripTitle),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Trip Overview'),
          _buildOverviewCard(),
          const SizedBox(height: 24),
          _buildSectionHeader('Itinerary'),
          _buildItineraryItem(
            'Day 1',
            'Arrival & Check-in',
            'Arrive at destination, check into hotel, explore nearby area',
            Icons.flight_land,
            Colors.blue,
          ),
          _buildItineraryItem(
            'Day 2',
            'City Tour',
            'Visit main attractions, historical sites, and local markets',
            Icons.location_city,
            Colors.orange,
          ),
          _buildItineraryItem(
            'Day 3',
            'Cultural Experience',
            'Museum visits, local cuisine tasting, cultural shows',
            Icons.museum,
            Colors.purple,
          ),
          _buildItineraryItem(
            'Day 4',
            'Adventure Day',
            'Outdoor activities, nature exploration, adventure sports',
            Icons.hiking,
            Colors.green,
          ),
          _buildItineraryItem(
            'Day 5',
            'Departure',
            'Last-minute shopping, checkout, depart for home',
            Icons.flight_takeoff,
            Colors.red,
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            context,
            'View Hotels',
            Icons.hotel,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelList(tripTitle: tripTitle),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00897B),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOverviewRow(Icons.calendar_today, 'Duration', '5 Days'),
            const Divider(height: 24),
            _buildOverviewRow(Icons.people, 'Travelers', '2 Adults'),
            const Divider(height: 24),
            _buildOverviewRow(Icons.attach_money, 'Budget', '\$2,500'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00897B), size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildItineraryItem(
      String day,
      String title,
      String description,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
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

  Widget _buildActionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00897B),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }
}