import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:latlong2/latlong.dart'; // Add this package
import 'package:flutter_map/flutter_map.dart'; // Add this package
import 'package:http/http.dart' as http;

import '../Services/location/hotel_model.dart';
import '../Services/location/hotel_service.dart'; // Add this package

class MapView extends StatefulWidget {
  final String tripTitle;
  final LatLng? initialLocation;
  final Hotel? selectedHotel; // Make sure this exists

  const MapView({
    super.key,
    required this.tripTitle,
    this.initialLocation,
    this.selectedHotel, // Make sure this exists
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  String _selectedView = 'route';
  List<Map<String, dynamic>> _markers = [];
  List<LatLng> _routePoints = [];
  LatLng? _selectedLocation;
  MapController _mapController = MapController();
  bool _isLoading = false;
  List<Hotel> _nearbyHotels = [];
  List<Map<String, dynamic>> _nearbyPlaces = [];

  @override
  void initState() {
    super.initState();

    // Fix: Use selected hotel's location or initial location
    if (widget.selectedHotel != null) {
      _selectedLocation = widget.selectedHotel!.toLatLng();
      // Clear all markers and add only the selected hotel
      _markers = [
        {
          'lat': widget.selectedHotel!.lat,
          'lng': widget.selectedHotel!.lng,
          'label': '★',
          'color': 'red',
          'name': widget.selectedHotel!.name,
        },
      ];
    } else if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
    } else {
      _selectedLocation = const LatLng(48.8566, 2.3522); // Paris default
    }

    _loadInitialData();
  }

  // Add this method to your _MapViewState class in MapView.dart:
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use Nominatim API for geocoding
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=1',
        ),
        headers: {'User-Agent': 'TravelMateApp/1.0'},
      );

      if (response.statusCode == 200) {
        final results = json.decode(response.body);
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lon = double.parse(results[0]['lon']);

          setState(() {
            _selectedLocation = LatLng(lat, lon);
            _markers.clear(); // Clear existing markers
            _markers.add({
              'lat': lat,
              'lng': lon,
              'label': '📍',
              'color': 'blue',
              'name': results[0]['display_name'],
            });
          });

          // Move map to new location
          _mapController.move(_selectedLocation!, 15.0);
        }
      }
    } catch (e) {
      SnackbarHelper.showError(context, 'Failed to search location.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      // Only load data if not coming from hotel selection
      if (widget.selectedHotel == null) {
        await _loadMapData();
      }

      // Always fetch OSM data for current location
      await _fetchViewData();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Remove the old _loadMapData and replace with:
  Future<void> _loadMapData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/map_data.json',
      );
      final data = json.decode(response);

      // Only load markers if no hotel is selected
      if (widget.selectedHotel == null) {
        setState(() {
          _markers = List<Map<String, dynamic>>.from(data['markers']);
        });
      }
    } catch (e) {
      print('No local map data found: $e');
    }
  }

  // Update the view button functionality:
  Widget _buildViewButton(String label, String value, IconData icon) {
    final isSelected = _selectedView == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = value;
          _fetchViewData(); // This will fetch new data based on view
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade600 : Colors.transparent,
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

  // Add this method to fetch data based on view:
  Future<void> _fetchViewData() async {
    if (_selectedLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      switch (_selectedView) {
        case 'hotels':
          await _fetchNearbyHotels();
          break;
        case 'places':
          await _fetchNearbyPlacesOSM();
          break;
        case 'route':
          await _fetchRouteData();
          break;
      }
    } catch (e) {
      print('Error fetching view data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyHotels() async {
    // Clear existing markers
    _markers.clear();

    // Get all hotels from service (Static for map initially)
    final allHotels = HotelService.getStaticHotels();

    // Filter hotels near current location (within 50km radius)
    final nearbyHotels = allHotels.where((hotel) {
      // Exclude selected if any
      if (widget.selectedHotel != null && hotel.id == widget.selectedHotel!.id)
        return false;

      final distance = _calculateDistance(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
        hotel.lat,
        hotel.lng,
      );
      return distance < 50; // 50km radius
    }).toList();

    setState(() {
      _nearbyHotels = nearbyHotels;

      // Convert hotels to markers
      _markers = nearbyHotels.map((hotel) {
        return {
          'lat': hotel.lat,
          'lng': hotel.lng,
          'label': 'H',
          'color': 'green',
          'name': hotel.name,
        };
      }).toList();
    });
  }

  Future<void> _fetchNearbyPlacesOSM() async {
    if (_selectedLocation == null) return;

    try {
      final query =
          '''
        [out:json];
        node
          ["tourism"~"attraction|museum|gallery"]
          (around:5000,${_selectedLocation!.latitude},${_selectedLocation!.longitude});
        out body;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _nearbyPlaces = List<Map<String, dynamic>>.from(data['elements'] ?? []);

        setState(() {
          // Clear existing markers
          _markers.clear();

          // Add OSM places as markers
          _markers = _nearbyPlaces.map((place) {
            return {
              'lat': place['lat'],
              'lng': place['lon'],
              'label': 'P',
              'color': 'blue',
              'name': place['tags']['name'] ?? 'Place',
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching OSM places: $e');
    }
  }

  Future<void> _fetchRouteData() async {
    if (_markers.length >= 2) {
      try {
        // Get route between first two markers
        final start = _markers[0];
        final end = _markers[1];

        final response = await http.get(
          Uri.parse(
            'https://router.project-osrm.org/route/v1/driving/'
            '${start['lng']},${start['lat']};${end['lng']},${end['lat']}'
            '?overview=full&geometries=geojson',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final geometry = data['routes'][0]['geometry']['coordinates'];

          setState(() {
            _routePoints = List<LatLng>.from(
              geometry.map((coord) => LatLng(coord[1], coord[0])),
            );
          });
        }
      } catch (e) {
        print('Error fetching route: $e');
      }
    }
  }

  // Helper method to calculate distance
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R * asin(sqrt(a))
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map - Paris Vacation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // OSM Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation ?? const LatLng(48.8566, 2.3522),
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 3.0,
              onTap: (tapPosition, latLng) {
                // Handle map tap
                _onMapTap(latLng);
              },
            ),
            children: [
              // OSM Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.travelmate.app',
                subdomains: const ['a', 'b', 'c'],
              ),

              // Route Layer
              if (_selectedView == 'route' && _routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 4,
                    ),
                  ],
                ),

              // Markers Layer
              MarkerLayer(markers: _buildOSMMarkers()),
            ],
          ),

          // Search Bar
          Positioned(top: 16, left: 16, right: 16, child: _buildSearchBar()),

          // View Selector
          Positioned(
            top: 80,
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

          // Loading Indicator
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
              ),
            ),

          // Info Card
          Positioned(bottom: 16, left: 16, right: 16, child: _buildInfoCard()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _mapController.move(
                _selectedLocation ?? const LatLng(48.8566, 2.3522),
                15.0,
              );
            },
            backgroundColor: Colors.teal,
            mini: true,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              );
            },
            backgroundColor: Colors.teal,
            mini: true,
            child: const Icon(Icons.zoom_in, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              );
            },
            backgroundColor: Colors.teal,
            mini: true,
            child: const Icon(Icons.zoom_out, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
                onSubmitted: (value) {
                  _searchLocation(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildOSMMarkers() {
    return _markers.map((marker) {
      final color = _getColor(marker['color']);
      return Marker(
        width: 40,
        height: 50,
        point: LatLng(
          marker['lat'] ?? _selectedLocation!.latitude,
          marker['lng'] ?? _selectedLocation!.longitude,
        ),
        child: Column(
          // Change this line from "builder: (ctx) =>" to "child:"
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
                  marker['label'] ?? '!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(width: 2, height: 10, color: color),
          ],
        ),
      );
    }).toList();
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _markers.add({
        'lat': latLng.latitude,
        'lng': latLng.longitude,
        'label': (_markers.length + 1).toString(),
        'color': 'blue',
      });
    });
  }

  Future<void> _fetchOSMHotels(LatLng location) async {
    // Implement hotel search from OSM
  }

  Future<void> _fetchOSMPlaces(LatLng location) async {
    // Implement places search from OSM
  }

  Color _getColor(String name) {
    switch (name.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.teal.shade600,
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
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 14,
                        color: Colors.teal.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal.shade600,
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
              icon: Icon(
                Icons.directions,
                color: Colors.teal.shade600,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
