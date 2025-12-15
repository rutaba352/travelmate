import 'dart:collection';
import 'package:travelmate/Views/MapView.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Views/HotelDetails.dart';

import '../Services/location/hotel_model.dart';
import '../Services/location/hotel_service.dart';

class HotelList extends StatelessWidget {
  HotelList({super.key});

  // Hotel data matching each destination
  final List<Map<String, dynamic>> _hotels = [
    // ===== PAKISTANI DESTINATIONS HOTELS =====
    {
      'name': 'Serena Hunza',
      'location': 'Hunza Valley, Pakistan',
      'rating': 4.9,
      'price': 'PKR 25,000/night',
      'amenities': ['Mountain View', 'Free WiFi', 'Spa', 'Restaurant'],
      'image': 'assets/images/hotels/serena_hunza.jpeg'
      ,
      'description': 'Luxury hotel with panoramic views of the Karakoram mountains.',
    },
    {
      'name': 'Shangrila Resort',
      'location': 'Skardu, Pakistan',
      'rating': 4.8,
      'price': 'PKR 30,000/night',
      'amenities': ['Lake View', 'Pool', 'Garden', 'Free Breakfast'],
      'image': 'assets/images/hotels/shangrila_resort.jpeg',
      'description': 'Iconic resort known as "Heaven on Earth" with beautiful lakeside location.',
    },
    {
      'name': 'Serena Swat',
      'location': 'Swat Valley, Pakistan',
      'rating': 4.7,
      'price': 'PKR 20,000/night',
      'amenities': ['River View', 'Spa', 'Free WiFi', 'Parking'],
      'image': 'assets/images/hotels/serena_swat.jpeg',
      'description': 'Luxury hotel in the heart of Swat Valley with modern amenities.',
    },
    {
      'name': 'Raikot Serai',
      'location': 'Fairy Meadows, Pakistan',
      'rating': 4.9,
      'price': 'PKR 35,000/night',
      'amenities': ['Nanga Parbat View', 'Camping', 'Trekking Guide', 'Bonfire'],
      'image': 'assets/images/hotels/raikot_sarai.jpeg',
      'description': 'Mountain lodge offering breathtaking views of Nanga Parbat.',
    },
    {
      'name': 'Khan Hotel',
      'location': 'Naran Kaghan, Pakistan',
      'rating': 4.6,
      'price': 'PKR 18,000/night',
      'amenities': ['Lake Access', 'Heating', 'Restaurant', 'Free Parking'],
      'image': 'assets/images/hotels/khan_hotel.jpeg',
      'description': 'Premium hotel near Saif-ul-Malook Lake with modern facilities.',
    },
    {
      'name': 'Pearl Continental',
      'location': 'Lahore, Pakistan',
      'rating': 4.7,
      'price': 'PKR 15,000/night',
      'amenities': ['City View', 'Pool', 'Gym', 'Business Center'],
      'image': 'assets/images/hotels/pc_lahore.jpeg',
      'description': '5-star luxury hotel in the heart of Lahore with premium services.',
    },
    {
      'name': 'Pearl Continental Bhurban',
      'location': 'Murree, Pakistan',
      'rating': 4.4,
      'price': 'PKR 12,000/night',
      'amenities': ['Hill View', 'Skiing', 'Spa', 'Indoor Pool'],
      'image': 'assets/images/hotels/pc_bhurban.jpeg',
      'description': 'Luxury resort in Murree hills with all modern amenities.',
    },
    {
      'name': 'Hotel PTDC Mohenjo-daro',
      'location': 'Mohenjo-daro, Pakistan',
      'rating': 4.6,
      'price': 'PKR 10,000/night',
      'amenities': ['Historical Site', 'Museum Access', 'Garden', 'Restaurant'],
      'image': 'assets/images/hotels/ptdc.jpeg',
      'description': 'Hotel near UNESCO World Heritage site with archaeological theme.',
    },
    {
      'name': 'Movenpick Hotel',
      'location': 'Karachi, Pakistan',
      'rating': 4.3,
      'price': 'PKR 20,000/night',
      'amenities': ['Sea View', 'Pool', 'Beach Access', 'Spa'],
      'image': 'assets/images/hotels/movenpick.jpeg',
      'description': 'Luxury beachfront hotel with Arabian Sea views.',
    },
    {
      'name': 'Pearl Park Hotel Sharda',
      'location': 'Neelum Valley, Pakistan',
      'rating': 4.8,
      'price': 'PKR 28,000/night',
      'amenities': ['River View', 'Mountain View', 'Garden', 'Restaurant'],
      'image': 'assets/images/hotels/hotel_sharda.jpeg',
      'description': 'Beautiful hotel overlooking Neelum River in Kashmir.',
    },

    // ===== INTERNATIONAL DESTINATIONS HOTELS =====
    {
      'name': 'Soneva Fushi',
      'location': 'Maldives',
      'rating': 4.9,
      'price': 'PKR 450,000/night',
      'amenities': ['Overwater Villa', 'Private Pool', 'Diving', 'Spa'],
      'image': 'assets/images/hotels/soneva_fushi.jpeg',
      'description': 'Luxurious overwater villas in tropical paradise setting.',
    },
    {
      'name': 'Burj Al Arab',
      'location': 'Dubai, UAE',
      'rating': 4.7,
      'price': 'PKR 180,000/night',
      'amenities': ['7-star Luxury', 'Private Beach', 'Helipad', 'Butler Service'],
      'image': 'assets/images/hotels/burj_al_arab.jpeg',
      'description': 'Iconic 7-star hotel shaped like a sail on artificial island.',
    },
    {
      'name': 'Four Seasons Sultanahmet',
      'location': 'Istanbul, Turkey',
      'rating': 4.8,
      'price': 'PKR 200,000/night',
      'amenities': ['Historic Building', 'Hagia Sophia View', 'Spa', 'Rooftop'],
      'image': 'assets/images/hotels/foure_seasons.jpeg',
      'description': 'Luxury hotel in historic building with views of Blue Mosque.',
    },
    {
      'name': 'Mandarin Oriental',
      'location': 'Bangkok, Thailand',
      'rating': 4.6,
      'price': 'PKR 150,000/night',
      'amenities': ['River View', 'Award-winning Spa', 'Fine Dining', 'Pool'],
      'image': 'assets/images/hotels/mandarin.jpeg',
      'description': 'Legendary luxury hotel on Chao Phraya River.',
    },
    {
      'name': 'Ayana Resort',
      'location': 'Bali, Indonesia',
      'rating': 4.8,
      'price': 'PKR 220,000/night',
      'description': 'Luxury cliff-top resort with ocean views and private beach.',
      'amenities': ['Cliff-top Pool', 'Private Beach', 'Spa', 'Multiple Restaurants'],
      'image': 'assets/images/hotels/ayana.jpeg',
    },
    {
      'name': 'Le Bristol Paris',
      'location': 'Paris, France',
      'rating': 4.8,
      'price': 'PKR 550,000/night',
      'amenities': ['Eiffel Tower View', 'Michelin Star Restaurant', 'Spa', 'Rooftop Pool'],
      'image': 'assets/images/hotels/le_bristol.jpeg',
      'description': 'Palace hotel with French elegance near Champs-Élysées.',
    },
    {
      'name': 'Badrutt\'s Palace',
      'location': 'Swiss Alps, Switzerland',
      'rating': 4.9,
      'price': 'PKR 600,000/night',
      'amenities': ['Ski-in/Ski-out', 'Ice Rink', 'Multiple Restaurants', 'Spa'],
      'image': 'assets/images/hotels/badrutts.jpeg',
      'description': 'Luxury alpine hotel with direct ski access.',
    },
    {
      'name': 'Canaves Oia',
      'location': 'Santorini, Greece',
      'rating': 4.9,
      'price': 'PKR 400,000/night',
      'amenities': ['Caldera View', 'Infinity Pool', 'Private Terrace', 'Sunset View'],
      'image': 'assets/images/hotels/canaves.jpeg',
      'description': 'Luxury suites with iconic Santorini caldera views.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hotels',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal.shade600,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _hotels.length,
        itemBuilder: (context, index) {
          final hotel = _hotels[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildHotelCard(
              hotel['name'],
              hotel['location'],
              hotel['rating'],
              hotel['price'],
              hotel['amenities'],
              hotel['image'],
              hotel['description'],
              context,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHotelCard(
      String name,
      String location,
      double rating,
      String price,
      List<String> amenities,
      String imagePath,
      String description,
      BuildContext context,
      ) {
    return InkWell(
      onTap: () {
        // Find the hotel in HotelService by name
        Hotel? selectedHotel;
        try {
          selectedHotel = HotelService.getAllHotels().firstWhere(
                (h) => h.name.toLowerCase().contains(name.toLowerCase()),
          );
        } catch (e) {
          // If hotel not found, use default coordinates
          selectedHotel = Hotel(
            id: '0',
            name: name,
            description: description,
            location: location,
            lat: 33.6844, // Default Pakistan coordinates
            lng: 73.0479,
            imagePath: imagePath,
            rating: rating,
            price: double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapView(
              tripTitle: name,
              selectedHotel: selectedHotel, // Pass the Hotel object
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Hotel Image - will show actual image from assets
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.teal.shade50,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image not found
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.teal.shade300,
                                Colors.teal.shade600,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.hotel,
                              size: 80,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Wrap for amenities
                  amenities.isNotEmpty
                      ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                      : Container(),
                  const SizedBox(height: 12),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text('Book Hotel'),
                              content: Text('Book $name for your trip?'),
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
                                      '$name booked successfully!',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade600,
                                  ),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
}