import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  String _selectedView = 'route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map - Paris Vacation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
              ),
            ),
            child: CustomPaint(
              painter: MapPainter(),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildViewButton('Route', 'route', Icons.route),
                    ),
                    Expanded(
                      child: _buildViewButton('Hotels', 'hotels', Icons.hotel),
                    ),
                    Expanded(
                      child: _buildViewButton('Places', 'places', Icons.place),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: _buildMarkers(),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildInfoCard(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Zoom in');
            },
            child: const Icon(Icons.add, color: Color(0xFF00897B)),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Zoom out');
            },
            child: const Icon(Icons.remove, color: Color(0xFF00897B)),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'my_location',
            backgroundColor: const Color(0xFF00897B),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'My location');
            },
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(String label, String value, IconData icon) {
    final isSelected = _selectedView == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00897B) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkers() {
    return Stack(
      children: [
        _buildMarker(100, 150, 'A', Colors.red),
        _buildMarker(200, 250, 'B', Colors.blue),
        _buildMarker(150, 350, 'C', Colors.green),
        _buildMarker(280, 200, 'D', Colors.orange),
        _buildMarker(180, 450, 'E', Colors.purple),
      ],
    );
  }

  Widget _buildMarker(double left, double top, String label, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            height: 10,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    String title, subtitle, distance;

    switch (_selectedView) {
      case 'hotels':
        title = 'Grand Hotel Paris';
        subtitle = 'Champs-Élysées';
        distance = '2.5 km away';
        break;
      case 'places':
        title = 'Eiffel Tower';
        subtitle = 'Iconic landmark';
        distance = '1.8 km away';
        break;
      default:
        title = 'Your Route';
        subtitle = 'Total distance: 15.2 km';
        distance = 'Est. time: 25 min';
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF00897B),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        size: 14,
                        color: Color(0xFF00897B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF00897B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                SnackbarHelper.showInfo(context, 'Get directions');
              },
              icon: const Icon(
                Icons.directions,
                color: Color(0xFF00897B),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(100, 150);
    path.quadraticBezierTo(150, 200, 200, 250);
    path.lineTo(150, 350);
    path.quadraticBezierTo(200, 300, 280, 200);
    path.lineTo(180, 450);

    canvas.drawPath(path, paint);

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        gridPaint,
      );
    }

    for (var i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}