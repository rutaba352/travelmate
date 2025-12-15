import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Services/TouristSpotService.dart';
import 'package:travelmate/Services/location/hotel_service.dart';

class DataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedTouristSpots() async {
    final spots = TouristSpotService.getStaticSpots(); // Get static data
    final batch = _firestore.batch();

    for (var spot in spots) {
      // Use name as ID for easier reading or random ID
      // Using 'id' field if available, else generated
      String docId =
          spot['id'] ?? _firestore.collection('tourist_spots').doc().id;
      final docRef = _firestore.collection('tourist_spots').doc(docId);

      // Ensure data types are consistent
      batch.set(docRef, spot);
    }

    await batch.commit();
    print('Tourist spots seeded successfully.');
  }

  Future<void> seedHotels() async {
    final hotels = HotelService.getStaticHotels(); // Get static data
    final batch = _firestore.batch();

    for (var hotel in hotels) {
      // Convert Hotel object to Map if necessary
      // HotelService returns List<Hotel>, need toMap()
      // Assuming Hotel has toMap() or we construct it manually

      String docId = hotel.id;
      final docRef = _firestore.collection('hotels').doc(docId);

      final hotelMap = {
        'id': hotel.id,
        'name': hotel.name,
        'description': hotel.description,
        'location': hotel.location,
        'lat': hotel.lat,
        'lng': hotel.lng,
        'imagePath': hotel.imagePath,
        'rating': hotel.rating,
        'price': hotel.price,
        'amenities': hotel.amenities,
        'country': hotel.location.split(', ').last, // Simple country extraction
      };

      batch.set(docRef, hotelMap);
    }

    await batch.commit();
    print('Hotels seeded successfully.');
  }
}
