import 'package:cloud_firestore/cloud_firestore.dart';

class TouristSpotService {
  // Simulating Firestore 'touristSpots' collection
  // Converted from TouristSpotsList.dart hardcoded data to a service

  static Future<List<Map<String, dynamic>>> getAllSpots() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tourist_spots')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      }
    } catch (e) {
      print('Error fetching spots: $e');
    }
    // Fallback to empty or handle error
    return [];
  }

  static List<Map<String, dynamic>> getStaticSpots() {
    return [
      // ===== PAKISTAN DESTINATIONS =====

      // Hunza Valley
      {
        'id': '1',
        'name': 'Attabad Lake',
        'location': 'Hunza Valley, Pakistan',
        'image': 'assets/images/tourist_spots/shangrilla.jpeg',
        'category': 'Nature',
        'rating': '4.9',
        'reviews': 3200,
        'description':
            'Turquoise lake formed after earthquake with stunning mountain backdrop',
        'entryFee': 'PKR 500',
        'distance': 'From Hunza: 20 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '2',
        'name': 'Baltit Fort',
        'location': 'Hunza Valley, Pakistan',
        'image': 'assets/images/tourist_spots/baltit_fort.jpeg',
        'category': 'Historical',
        'rating': '4.7',
        'reviews': 2100,
        'description': 'Ancient fort with panoramic views of Hunza Valley',
        'entryFee': 'PKR 800',
        'distance': 'From Hunza: 2 km',
        'openTime': '9:00 AM - 5:00 PM',
        'isSaved': false,
      },

      // Skardu
      {
        'id': '3',
        'name': 'Shangrila Resort',
        'location': 'Skardu, Pakistan',
        'image': 'assets/images/tourist_spots/shangrilla.jpeg',
        'category': 'Nature',
        'rating': '4.8',
        'reviews': 2800,
        'description': 'Beautiful resort complex with Lower Kachura Lake',
        'entryFee': 'PKR 1000',
        'distance': 'From Skardu: 15 km',
        'openTime': '8:00 AM - 10:00 PM',
        'isSaved': false,
      },
      {
        'id': '4',
        'name': 'Deosai Plains',
        'location': 'Skardu, Pakistan',
        'image': 'assets/images/tourist_spots/deosai.jpeg',
        'category': 'Adventure',
        'rating': '4.9',
        'reviews': 1900,
        'description':
            'Second highest plateau in the world, summer habitat of Himalayan brown bears',
        'entryFee': 'PKR 500',
        'distance': 'From Skardu: 30 km',
        'openTime': '6:00 AM - 6:00 PM',
        'isSaved': false,
      },

      // Swat Valley
      {
        'id': '5',
        'name': 'Mahodand Lake',
        'location': 'Swat Valley, Pakistan',
        'image': 'assets/images/tourist_spots/mohmand.jpeg',
        'category': 'Nature',
        'rating': '4.7',
        'reviews': 2500,
        'description': 'Alpine lake surrounded by pine forests and mountains',
        'entryFee': 'PKR 400',
        'distance': 'From Kalam: 40 km',
        'openTime': '6:00 AM - 5:00 PM',
        'isSaved': false,
      },
      {
        'id': '6',
        'name': 'Malam Jabba',
        'location': 'Swat Valley, Pakistan',
        'image': 'assets/images/tourist_spots/malam_jabba.jpeg',
        'category': 'Adventure',
        'rating': '4.5',
        'reviews': 1800,
        'description':
            'Only ski resort in Pakistan with chairlifts and snow activities',
        'entryFee': 'PKR 1200',
        'distance': 'From Mingora: 40 km',
        'openTime': '8:00 AM - 6:00 PM',
        'isSaved': false,
      },

      // Fairy Meadows
      {
        'id': '7',
        'name': 'Nanga Parbat Viewpoint',
        'location': 'Fairy Meadows, Pakistan',
        'image': 'assets/images/tourist_spots/viewpoint.jpeg',
        'category': 'Adventure',
        'rating': '4.9',
        'reviews': 1500,
        'description': 'Closest view of Nanga Parbat, the killer mountain',
        'entryFee': 'PKR 500',
        'distance': 'From Fairy Meadows: 3 km trek',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '8',
        'name': 'Beyal Camp',
        'location': 'Fairy Meadows, Pakistan',
        'image': 'assets/images/tourist_spots/beyal_camp.jpeg',
        'category': 'Adventure',
        'rating': '4.6',
        'reviews': 1200,
        'description': 'Base camp for trekkers with amazing mountain views',
        'entryFee': 'PKR 300',
        'distance': 'From Fairy Meadows: 5 km',
        'openTime': '24/7',
        'isSaved': false,
      },

      // Naran Kaghan
      {
        'id': '9',
        'name': 'Lake Saif-ul-Malook',
        'location': 'Naran, Pakistan',
        'image': 'assets/images/tourist_spots/saiful_malook.jpeg',
        'category': 'Nature',
        'rating': '4.8',
        'reviews': 3500,
        'description':
            'High-altitude alpine lake with crystal clear waters and legend',
        'entryFee': 'PKR 600',
        'distance': 'From Naran: 9 km',
        'openTime': '7:00 AM - 5:00 PM',
        'isSaved': false,
      },
      {
        'id': '10',
        'name': 'Babusar Pass',
        'location': 'Naran, Pakistan',
        'image': 'assets/images/tourist_spots/babusar.jpeg',
        'category': 'Adventure',
        'rating': '4.7',
        'reviews': 2200,
        'description':
            'Highest point on Naran-Chilas road with breathtaking views',
        'entryFee': 'Free',
        'distance': 'From Naran: 60 km',
        'openTime': '24/7 (May-Oct only)',
        'isSaved': false,
      },

      // Lahore
      {
        'id': '11',
        'name': 'Badshahi Mosque',
        'location': 'Lahore, Pakistan',
        'image': 'assets/images/tourist_spots/mosque.jpeg',
        'category': 'Historical',
        'rating': '4.8',
        'reviews': 4200,
        'description':
            'One of the largest mosques in the world, Mughal architecture',
        'entryFee': 'PKR 500',
        'distance': 'From Lahore Center: 3 km',
        'openTime': '8:00 AM - 8:00 PM',
        'isSaved': false,
      },
      {
        'id': '12',
        'name': 'Lahore Fort',
        'location': 'Lahore, Pakistan',
        'image': 'assets/images/tourist_spots/lahore_fort.jpeg',
        'category': 'Historical',
        'rating': '4.7',
        'reviews': 3800,
        'description':
            'UNESCO World Heritage Site, Mughal and Sikh architecture',
        'entryFee': 'PKR 500',
        'distance': 'From Lahore Center: 3.5 km',
        'openTime': '8:30 AM - 5:00 PM',
        'isSaved': false,
      },

      // Murree
      {
        'id': '13',
        'name': 'Mall Road',
        'location': 'Murree, Pakistan',
        'image': 'assets/images/tourist_spots/mall_road.jpeg',
        'category': 'Shopping',
        'rating': '4.3',
        'reviews': 3200,
        'description':
            'Famous shopping street with colonial-era buildings and views',
        'entryFee': 'Free',
        'distance': 'From Murree Center: 0 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '14',
        'name': 'Patriata Chairlift',
        'location': 'Murree, Pakistan',
        'image': 'assets/images/tourist_spots/patriata.jpeg',
        'category': 'Adventure',
        'rating': '4.5',
        'reviews': 2800,
        'description': 'Chairlift ride offering panoramic views of mountains',
        'entryFee': 'PKR 800',
        'distance': 'From Murree: 15 km',
        'openTime': '9:00 AM - 5:00 PM',
        'isSaved': false,
      },

      // Mohenjo-daro
      {
        'id': '15',
        'name': 'Mohenjo-daro Ruins',
        'location': 'Mohenjo-daro, Pakistan',
        'image': 'assets/images/tourist_spots/museum.jpeg',
        'category': 'Historical',
        'rating': '4.6',
        'reviews': 1800,
        'description':
            'Archaeological site of ancient Indus Valley Civilization',
        'entryFee': 'PKR 300',
        'distance': 'From Larkana: 30 km',
        'openTime': '8:30 AM - 5:30 PM',
        'isSaved': false,
      },
      {
        'id': '16',
        'name': 'Mohenjo-daro Museum',
        'location': 'Mohenjo-daro, Pakistan',
        'image': 'assets/images/mohenjo_daro.jpg',
        'category': 'Cultural',
        'rating': '4.4',
        'reviews': 1200,
        'description':
            'Museum showcasing artifacts from Indus Valley Civilization',
        'entryFee': 'PKR 200',
        'distance': 'Within Mohenjo-daro site',
        'openTime': '9:00 AM - 4:00 PM',
        'isSaved': false,
      },

      // Karachi
      {
        'id': '17',
        'name': 'Clifton Beach',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/tourist_spots/clifton.jpeg',
        'category': 'Beach',
        'rating': '4.3',
        'reviews': 4500,
        'description':
            'Popular beach for camel rides, horse rides, and sunset views',
        'entryFee': 'Free',
        'distance': 'From Karachi Center: 8 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '18',
        'name': 'Mohatta Palace',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/tourist_spots/mohatta.jpeg',
        'category': 'Cultural',
        'rating': '4.5',
        'reviews': 2100,
        'description':
            'Palace turned museum with beautiful architecture and art exhibitions',
        'entryFee': 'PKR 300',
        'distance': 'From Karachi Center: 12 km',
        'openTime': '11:00 AM - 6:00 PM',
        'isSaved': false,
      },

      // Neelum Valley
      {
        'id': '19',
        'name': 'Sharda Peeth',
        'location': 'Neelum Valley, Pakistan',
        'image': 'assets/images/tourist_spots/sharda.jpeg',
        'category': 'Historical',
        'rating': '4.7',
        'reviews': 1600,
        'description':
            'Ancient Hindu temple and Buddhist learning center ruins',
        'entryFee': 'Free',
        'distance': 'From Athmuqam: 40 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '20',
        'name': 'Ratti Gali Lake',
        'location': 'Neelum Valley, Pakistan',
        'image': 'assets/images/tourist_spots/ratti_gali.jpeg',
        'category': 'Nature',
        'rating': '4.8',
        'reviews': 1400,
        'description': 'High-altitude glacial lake with emerald green waters',
        'entryFee': 'PKR 500',
        'distance': 'From Dowarian: 16 km trek',
        'openTime': '6:00 AM - 4:00 PM',
        'isSaved': false,
      },

      // ===== INTERNATIONAL DESTINATIONS =====

      // Maldives
      {
        'id': '21',
        'name': 'Artificial Beach',
        'location': 'Malé, Maldives',
        'image': 'assets/images/tourist_spots/male_beach.jpeg',
        'category': 'Beach',
        'rating': '4.8',
        'reviews': 3800,
        'description': 'Popular public beach with white sand and clear waters',
        'entryFee': 'Free',
        'distance': 'From Malé: 2 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '22',
        'name': 'National Museum',
        'location': 'Malé, Maldives',
        'image': 'assets/images/tourist_spots/male_museum.jpeg',
        'category': 'Cultural',
        'rating': '4.5',
        'reviews': 2100,
        'description': 'Showcasing Maldivian history and cultural artifacts',
        'entryFee': 'MVR 100',
        'distance': 'From Malé Center: 1 km',
        'openTime': '9:00 AM - 5:00 PM',
        'isSaved': false,
      },

      // Dubai
      {
        'id': '23',
        'name': 'Burj Khalifa',
        'location': 'Dubai, UAE',
        'image': 'assets/images/tourist_spots/burj_khalifa.jpeg',
        'category': 'Adventure',
        'rating': '4.9',
        'reviews': 5200,
        'description': 'World\'s tallest building with observation decks',
        'entryFee': 'AED 149',
        'distance': 'From Dubai Center: 10 km',
        'openTime': '8:30 AM - 11:00 PM',
        'isSaved': false,
      },
      {
        'id': '24',
        'name': 'Dubai Mall',
        'location': 'Dubai, UAE',
        'image': 'assets/images/tourist_spots/dubai_mall.jpeg',
        'category': 'Shopping',
        'rating': '4.8',
        'reviews': 4800,
        'description':
            'World\'s largest shopping mall with aquarium and fountain shows',
        'entryFee': 'Free',
        'distance': 'From Dubai Center: 12 km',
        'openTime': '10:00 AM - 12:00 AM',
        'isSaved': false,
      },

      // Istanbul
      {
        'id': '25',
        'name': 'Hagia Sophia',
        'location': 'Istanbul, Turkey',
        'image': 'assets/images/tourist_spots/hajia_sophia.jpeg',
        'category': 'Historical',
        'rating': '4.9',
        'reviews': 4500,
        'description': 'Architectural marvel, former church and mosque',
        'entryFee': '₺450',
        'distance': 'From Sultanahmet: 0 km',
        'openTime': '9:00 AM - 7:30 PM',
        'isSaved': false,
      },
      {
        'id': '26',
        'name': 'Grand Bazaar',
        'location': 'Istanbul, Turkey',
        'image': 'assets/images/tourist_spots/grand_bazar.jpeg',
        'category': 'Shopping',
        'rating': '4.7',
        'reviews': 3900,
        'description': 'One of the world\'s oldest and largest covered markets',
        'entryFee': 'Free',
        'distance': 'From Sultanahmet: 1.5 km',
        'openTime': '8:30 AM - 7:00 PM',
        'isSaved': false,
      },

      // Bangkok
      {
        'id': '27',
        'name': 'Wat Arun',
        'location': 'Bangkok, Thailand',
        'image': 'assets/images/tourist_spots/wat_arun.jpeg',
        'category': 'Religious',
        'rating': '4.7',
        'reviews': 3200,
        'description': 'Temple of Dawn with stunning porcelain decoration',
        'entryFee': '฿100',
        'distance': 'From Bangkok Center: 5 km',
        'openTime': '8:00 AM - 6:00 PM',
        'isSaved': false,
      },
      {
        'id': '28',
        'name': 'Chatuchak Market',
        'location': 'Bangkok, Thailand',
        'image': 'assets/images/tourist_spots/chatuchak.jpeg',
        'category': 'Shopping',
        'rating': '4.6',
        'reviews': 2800,
        'description': 'World\'s largest weekend market with 15,000 stalls',
        'entryFee': 'Free',
        'distance': 'From Bangkok Center: 10 km',
        'openTime': '9:00 AM - 6:00 PM',
        'isSaved': false,
      },

      // Bali
      {
        'id': '29',
        'name': 'Tanah Lot',
        'location': 'Bali, Indonesia',
        'image': 'assets/images/tourist_spots/tanah_lot.jpeg',
        'category': 'Religious',
        'rating': '4.8',
        'reviews': 4100,
        'description': 'Ancient Hindu temple on rocky island with sunset views',
        'entryFee': 'Rp 60,000',
        'distance': 'From Denpasar: 20 km',
        'openTime': '7:00 AM - 7:00 PM',
        'isSaved': false,
      },
      {
        'id': '30',
        'name': 'Ubud Monkey Forest',
        'location': 'Bali, Indonesia',
        'image': 'assets/images/tourist_spots/ubud_money_forest.jpeg',
        'category': 'Nature',
        'rating': '4.6',
        'reviews': 3500,
        'description': 'Sacred monkey sanctuary in lush forest',
        'entryFee': 'Rp 80,000',
        'distance': 'From Ubud: 2 km',
        'openTime': '9:00 AM - 6:00 PM',
        'isSaved': false,
      },

      // Paris
      {
        'id': '31',
        'name': 'Eiffel Tower',
        'location': 'Paris, France',
        'image': 'assets/images/tourist_spots/eiffel_tower.jpeg',
        'category': 'Historical',
        'rating': '4.8',
        'reviews': 12500,
        'description': 'Iconic iron lattice tower and symbol of Paris',
        'entryFee': '\$25',
        'distance': 'From Paris Center: 2.5 km',
        'openTime': '9:00 AM - 11:00 PM',
        'isSaved': false,
      },
      {
        'id': '32',
        'name': 'Louvre Museum',
        'location': 'Paris, France',
        'image': 'assets/images/tourist_spots/louvre_museum.jpeg',
        'category': 'Cultural',
        'rating': '4.9',
        'reviews': 18700,
        'description': 'World\'s largest art museum and historic monument',
        'entryFee': '\$20',
        'distance': 'From Paris Center: 3.2 km',
        'openTime': '9:00 AM - 6:00 PM',
        'isSaved': true,
      },

      // Swiss Alps
      {
        'id': '33',
        'name': 'Jungfraujoch',
        'location': 'Swiss Alps, Switzerland',
        'image': 'assets/images/tourist_spots/jungfrau.jpeg',
        'category': 'Adventure',
        'rating': '4.9',
        'reviews': 3800,
        'description': 'Top of Europe - highest railway station in Europe',
        'entryFee': 'CHF 210',
        'distance': 'From Interlaken: 40 km',
        'openTime': '8:00 AM - 4:00 PM',
        'isSaved': false,
      },
      {
        'id': '34',
        'name': 'Matterhorn Glacier Paradise',
        'location': 'Swiss Alps, Switzerland',
        'image': 'assets/images/tourist_spots/matterhorn.jpeg',
        'category': 'Adventure',
        'rating': '4.8',
        'reviews': 3200,
        'description':
            'Highest cable car station in Europe with glacier palace',
        'entryFee': 'CHF 95',
        'distance': 'From Zermatt: 15 km',
        'openTime': '8:30 AM - 4:30 PM',
        'isSaved': false,
      },

      // Santorini
      {
        'id': '35',
        'name': 'Oia Sunset Viewpoint',
        'location': 'Santorini, Greece',
        'image': 'assets/images/tourist_spots/oia_sunset.jpeg',
        'category': 'Nature',
        'rating': '4.9',
        'reviews': 4500,
        'description':
            'Most famous sunset spot with white and blue architecture',
        'entryFee': 'Free',
        'distance': 'From Fira: 12 km',
        'openTime': '24/7',
        'isSaved': false,
      },
      {
        'id': '36',
        'name': 'Red Beach',
        'location': 'Santorini, Greece',
        'image': 'assets/images/tourist_spots/red_beach.jpeg',
        'category': 'Beach',
        'rating': '4.7',
        'reviews': 2900,
        'description': 'Unique beach with red volcanic cliffs and sand',
        'entryFee': 'Free',
        'distance': 'From Fira: 12 km',
        'openTime': '24/7',
        'isSaved': false,
      },
    ];
  }

  static Map<String, dynamic>? getSpotById(String id) {
    try {
      return getStaticSpots().firstWhere((s) => s['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
