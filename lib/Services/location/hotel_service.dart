import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Services/location/hotel_model.dart';

class HotelService {
  static Future<List<Hotel>> getAllHotels() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Hotel(
            id: data['id'] ?? doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            location: data['location'] ?? '',
            lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
            lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
            imagePath: data['imagePath'] ?? 'assets/images/placeholder.jpg',
            rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            amenities: List<String>.from(data['amenities'] ?? []),
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching hotels: $e');
    }
    return [];
  }

  static List<Hotel> getStaticHotels() {
    return [
      // ===== PAKISTANI DESTINATIONS HOTELS =====
      Hotel(
        id: '1',
        name: 'Serena Hunza',
        location: 'Hunza Valley, Pakistan',
        rating: 4.9,
        price: 25000,
        amenities: ['Mountain View', 'Free WiFi', 'Spa', 'Restaurant'],
        imagePath: 'assets/images/hotels/serena_hunza.jpeg',
        description:
            'Luxury hotel with panoramic views of the Karakoram mountains.',
        lat: 36.3167,
        lng: 74.6500,
      ),
      Hotel(
        id: '2',
        name: 'Shangrila Resort',
        location: 'Skardu, Pakistan',
        rating: 4.8,
        price: 30000,
        amenities: ['Lake View', 'Pool', 'Garden', 'Free Breakfast'],
        imagePath: 'assets/images/hotels/shangrila_resort.jpeg',
        description:
            'Iconic resort known as "Heaven on Earth" with beautiful lakeside location.',
        lat: 35.3562,
        lng: 75.5134,
      ),
      Hotel(
        id: '3',
        name: 'Serena Swat',
        location: 'Swat Valley, Pakistan',
        rating: 4.7,
        price: 20000,
        amenities: ['River View', 'Spa', 'Free WiFi', 'Parking'],
        imagePath: 'assets/images/hotels/serena_swat.jpeg',
        description:
            'Luxury hotel in the heart of Swat Valley with modern amenities.',
        lat: 34.7500,
        lng: 72.3572,
      ),
      Hotel(
        id: '4',
        name: 'Raikot Serai',
        location: 'Fairy Meadows, Pakistan',
        rating: 4.9,
        price: 35000,
        amenities: [
          'Nanga Parbat View',
          'Camping',
          'Trekking Guide',
          'Bonfire',
        ],
        imagePath: 'assets/images/hotels/raikot_sarai.jpeg',
        description:
            'Mountain lodge offering breathtaking views of Nanga Parbat.',
        lat: 35.3850,
        lng: 74.5776,
      ),
      Hotel(
        id: '5',
        name: 'Khan Hotel',
        location: 'Naran Kaghan, Pakistan',
        rating: 4.6,
        price: 18000,
        amenities: ['Lake Access', 'Heating', 'Restaurant', 'Free Parking'],
        imagePath: 'assets/images/hotels/khan_hotel.jpeg',
        description:
            'Premium hotel near Saif-ul-Malook Lake with modern facilities.',
        lat: 34.9084,
        lng: 73.6508,
      ),
      Hotel(
        id: '6',
        name: 'Pearl Continental',
        location: 'Lahore, Pakistan',
        rating: 4.7,
        price: 15000,
        amenities: ['City View', 'Pool', 'Gym', 'Business Center'],
        imagePath: 'assets/images/hotels/pc_lahore.jpeg',
        description:
            '5-star luxury hotel in the heart of Lahore with premium services.',
        lat: 31.5546,
        lng: 74.3572,
      ),
      Hotel(
        id: '7',
        name: 'Pearl Continental Bhurban',
        location: 'Murree, Pakistan',
        rating: 4.4,
        price: 12000,
        amenities: ['Hill View', 'Skiing', 'Spa', 'Indoor Pool'],
        imagePath: 'assets/images/hotels/pc_bhurban.jpeg',
        description: 'Luxury resort in Murree hills with all modern amenities.',
        lat: 33.9555,
        lng: 73.4519,
      ),
      Hotel(
        id: '8',
        name: 'Hotel PTDC Mohenjo-daro',
        location: 'Mohenjo-daro, Pakistan',
        rating: 4.6,
        price: 10000,
        amenities: ['Historical Site', 'Museum Access', 'Garden', 'Restaurant'],
        imagePath: 'assets/images/hotels/ptdc.jpeg',
        description:
            'Hotel near UNESCO World Heritage site with archaeological theme.',
        lat: 27.3292,
        lng: 68.1384,
      ),
      Hotel(
        id: '9',
        name: 'Movenpick Hotel',
        location: 'Karachi, Pakistan',
        rating: 4.3,
        price: 20000,
        amenities: ['Sea View', 'Pool', 'Beach Access', 'Spa'],
        imagePath: 'assets/images/hotels/movenpick.jpeg',
        description: 'Luxury beachfront hotel with Arabian Sea views.',
        lat: 24.8465,
        lng: 67.0326,
      ),
      Hotel(
        id: '10',
        name: 'Pearl Park Hotel Sharda',
        location: 'Neelum Valley, Pakistan',
        rating: 4.8,
        price: 28000,
        amenities: ['River View', 'Mountain View', 'Garden', 'Restaurant'],
        imagePath: 'assets/images/hotels/hotel_sharda.jpeg',
        description: 'Beautiful hotel overlooking Neelum River in Kashmir.',
        lat: 34.7937,
        lng: 74.1866,
      ),

      // ===== INTERNATIONAL DESTINATIONS HOTELS =====
      Hotel(
        id: '11',
        name: 'Soneva Fushi',
        location: 'Maldives',
        rating: 4.9,
        price: 450000,
        amenities: ['Overwater Villa', 'Private Pool', 'Diving', 'Spa'],
        imagePath: 'assets/images/hotels/soneva_fushi.jpeg',
        description: 'Luxurious overwater villas in tropical paradise setting.',
        lat: 5.1117,
        lng: 73.0264,
      ),
      Hotel(
        id: '12',
        name: 'Burj Al Arab',
        location: 'Dubai, UAE',
        rating: 4.7,
        price: 180000,
        amenities: [
          '7-star Luxury',
          'Private Beach',
          'Helipad',
          'Butler Service',
        ],
        imagePath: 'assets/images/hotels/burj_al_arab.jpeg',
        description:
            'Iconic 7-star hotel shaped like a sail on artificial island.',
        lat: 25.1412,
        lng: 55.1852,
      ),
      Hotel(
        id: '13',
        name: 'Four Seasons Sultanahmet',
        location: 'Istanbul, Turkey',
        rating: 4.8,
        price: 200000,
        amenities: ['Historic Building', 'Hagia Sophia View', 'Spa', 'Rooftop'],
        imagePath: 'assets/images/hotels/foure_seasons.jpeg',
        description:
            'Luxury hotel in historic building with views of Blue Mosque.',
        lat: 41.0054,
        lng: 28.9768,
      ),
      Hotel(
        id: '14',
        name: 'Mandarin Oriental',
        location: 'Bangkok, Thailand',
        rating: 4.6,
        price: 150000,
        amenities: ['River View', 'Award-winning Spa', 'Fine Dining', 'Pool'],
        imagePath: 'assets/images/hotels/mandarin.jpeg',
        description: 'Legendary luxury hotel on Chao Phraya River.',
        lat: 13.7229,
        lng: 100.5135,
      ),
      Hotel(
        id: '15',
        name: 'Ayana Resort',
        location: 'Bali, Indonesia',
        rating: 4.8,
        price: 220000,
        amenities: [
          'Cliff-top Pool',
          'Private Beach',
          'Spa',
          'Multiple Restaurants',
        ],
        imagePath: 'assets/images/hotels/ayana.jpeg',
        description:
            'Luxury cliff-top resort with ocean views and private beach.',
        lat: -8.7845,
        lng: 115.1226,
      ),
      Hotel(
        id: '16',
        name: 'Le Bristol Paris',
        location: 'Paris, France',
        rating: 4.8,
        price: 550000,
        amenities: [
          'Eiffel Tower View',
          'Michelin Star Restaurant',
          'Spa',
          'Rooftop Pool',
        ],
        imagePath: 'assets/images/hotels/le_bristol.jpeg',
        description: 'Palace hotel with French elegance near Champs-Élysées.',
        lat: 48.8722,
        lng: 2.3125,
      ),
      Hotel(
        id: '17',
        name: 'Badrutt\'s Palace',
        location: 'Swiss Alps, Switzerland',
        rating: 4.9,
        price: 600000,
        amenities: [
          'Ski-in/Ski-out',
          'Ice Rink',
          'Multiple Restaurants',
          'Spa',
        ],
        imagePath: 'assets/images/hotels/badrutts.jpeg',
        description: 'Luxury alpine hotel with direct ski access.',
        lat: 46.4975,
        lng: 9.8398,
      ),
      Hotel(
        id: '18',
        name: 'Canaves Oia',
        location: 'Santorini, Greece',
        rating: 4.9,
        price: 400000,
        amenities: [
          'Caldera View',
          'Infinity Pool',
          'Private Terrace',
          'Sunset View',
        ],
        imagePath: 'assets/images/hotels/canaves.jpeg',
        description: 'Luxury suites with iconic Santorini caldera views.',
        lat: 36.4623,
        lng: 25.3758,
      ),
    ];
  }

  static Hotel? findHotelByName(String name) {
    try {
      return getStaticHotels().firstWhere(
        // Fallback to static for sync helper
        (hotel) => hotel.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

  static List<Hotel> getHotelsByCountry(String country) {
    // Fallback to static for sync helper or update to Future if needed
    return getStaticHotels()
        .where((hotel) => hotel.location.contains(country))
        .toList();
  }
}
