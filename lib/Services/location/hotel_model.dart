import 'package:latlong2/latlong.dart';

class Hotel {
  final String id;
  final String name;
  final String description;
  final String location;
  final double lat;
  final double lng;
  final String imagePath;
  final double rating;
  final double price;
  final List<String> amenities;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.lat,
    required this.lng,
    required this.imagePath,
    required this.rating,
    required this.price,
    this.amenities = const [],
  });

  // Convert to LatLng for map
  LatLng toLatLng() => LatLng(lat, lng);
}
