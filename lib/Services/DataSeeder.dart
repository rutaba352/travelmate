import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedActivities() async {
    final batch = _firestore.batch();
    
    // PARIS ACTIVITIES
    final parisActivities = [
      {
        'cityId': 'paris',
        'name': 'Eiffel Tower Tour',
        'category': 'Sightseeing',
        'description': 'Visit the iconic Eiffel Tower with skip-the-line access.',
        'price': '€25',
        'rating': 4.8,
        'reviews': 1200,
        'duration': '2 hours',
        'image': 'assets/images/paris.jpg', // Local or URL
        'location': 'Champ de Mars, Paris',
        'difficulty': 'Easy',
        'isSaved': false,
      },
      {
        'cityId': 'paris',
        'name': 'Seine River Cruise',
        'category': 'Entertainment',
        'description': 'Romantic boat ride along the Seine river at sunset.',
        'price': '€18',
        'rating': 4.7,
        'reviews': 850,
        'duration': '1.5 hours',
        'image': 'assets/images/paris.jpg',
        'location': 'Port de la Bourdonnais',
        'difficulty': 'Easy',
        'isSaved': false,
      },
       {
        'cityId': 'paris',
        'name': 'Louvre Museum Guided Tour',
        'category': 'Culture',
        'description': 'Discover masterpieces like the Mona Lisa.',
        'price': '€40',
        'rating': 4.9,
        'reviews': 2100,
        'duration': '3 hours',
        'image': 'assets/images/paris.jpg',
        'location': 'Rue de Rivoli',
        'difficulty': 'Moderate',
        'isSaved': false,
      },
    ];

    // LAHORE ACTIVITIES
    final lahoreActivities = [
      {
        'cityId': 'lahore',
        'name': 'Badshahi Mosque Visit',
        'category': 'Culture',
        'description': 'Explore the magnificent Mughal architecture of Badshahi Mosque.',
        'price': 'PKR 500',
        'rating': 4.9,
        'reviews': 3200,
        'duration': '1 hour',
        'image': 'assets/images/lahore.jpg',
        'location': 'Walled City, Lahore',
        'difficulty': 'Easy',
        'isSaved': false,
      },
      {
        'cityId': 'lahore',
        'name': 'Lahore Fort Tour',
        'category': 'Sightseeing',
        'description': 'Guided tour of the UNESCO World Heritage Site.',
        'price': 'PKR 800',
        'rating': 4.8,
        'reviews': 1500,
        'duration': '2 hours',
        'image': 'assets/images/lahore.jpg',
        'location': 'Walled City, Lahore',
        'difficulty': 'Moderate',
        'isSaved': false,
      },
      {
        'cityId': 'lahore',
        'name': 'Food Street Dinner',
        'category': 'Food',
        'description': 'Traditional dinner with a view of the mosque.',
        'price': 'PKR 2500',
        'rating': 4.7,
        'reviews': 2800,
        'duration': '2 hours',
        'image': 'assets/images/lahore.jpg',
        'location': 'Fort Road Food Street',
        'difficulty': 'Easy',
        'isSaved': false,
      },
    ];

    // DUBAI ACTIVITIES
    final dubaiActivities = [
      {
        'cityId': 'dubai',
        'name': 'Burj Khalifa Top View',
        'category': 'Sightseeing',
        'description': 'View the city from the tallest building in the world.',
        'price': 'AED 150',
        'rating': 4.9,
        'reviews': 5000,
        'duration': '2 hours',
        'image': 'assets/images/dubai.jpg',
        'location': 'Downtown Dubai',
        'difficulty': 'Easy',
        'isSaved': false,
      },
      {
        'cityId': 'dubai',
        'name': 'Desert Safari',
        'category': 'Adventure',
        'description': 'Dune bashing, camel riding, and BBQ dinner.',
        'price': 'AED 200',
        'rating': 4.8,
        'reviews': 3200,
        'duration': '6 hours',
        'image': 'assets/images/dubai.jpg',
        'location': 'Dubai Desert',
        'difficulty': 'Moderate',
        'isSaved': false,
      },
    ];

    // LONDON ACTIVITIES
    final londonActivities = [
      {
        'cityId': 'london',
        'name': 'London Eye Ticket',
        'category': 'Sightseeing',
        'description': 'Ride the famous Ferris wheel on the South Bank.',
        'price': '£30',
        'rating': 4.6,
        'reviews': 4100,
        'duration': '30 mins',
        'image': 'assets/images/london.jpg',
        'location': 'South Bank, London',
        'difficulty': 'Easy',
        'isSaved': false,
      },
      {
        'cityId': 'london',
        'name': 'British Museum Tour',
        'category': 'Culture',
        'description': 'Explore human history and culture.',
        'price': 'Free',
        'rating': 4.8,
        'reviews': 2900,
        'duration': '3 hours',
        'image': 'assets/images/london.jpg',
        'location': 'Bloomsbury, London',
        'difficulty': 'Easy',
        'isSaved': false,
      },
    ];

    // KARACHI ACTIVITIES
    final karachiActivities = [
      {
        'cityId': 'karachi',
        'name': 'Clifton Beach Camel Ride',
        'category': 'Entertainment',
        'description': 'Enjoy a camel ride on the Seaview beach.',
        'price': 'PKR 300',
        'rating': 4.5,
        'reviews': 1200,
        'duration': '1 hour',
        'image': 'assets/images/karachi.jpg',
        'location': 'Clifton, Karachi',
        'difficulty': 'Easy',
        'isSaved': false,
      },
      {
        'cityId': 'karachi',
        'name': 'Mohatta Palace Museum',
        'category': 'Culture',
        'description': 'Visit the beautiful Rajasthani style palace.',
        'price': 'PKR 100',
        'rating': 4.7,
        'reviews': 800,
        'duration': '2 hours',
        'image': 'assets/images/karachi.jpg',
        'location': 'Clifton, Karachi',
        'difficulty': 'Easy',
        'isSaved': false,
      },
    ];

    // NEW YORK ACTIVITIES
    final newYorkActivities = [
      {
        'cityId': 'new york',
        'name': 'Statue of Liberty Cruise',
        'category': 'Sightseeing',
        'description': 'Boat tour around the Statue of Liberty.',
        'price': '\$30',
        'rating': 4.8,
        'reviews': 6000,
        'duration': '2 hours',
        'image': 'assets/images/new_york.jpg',
        'location': 'New York Harbor',
        'difficulty': 'Easy',
        'isSaved': false,
      },
    ];

    // BANGKOK ACTIVITIES
    final bangkokActivities = [
       {
        'cityId': 'bangkok',
        'name': 'Grand Palace Tour',
        'category': 'Culture',
        'description': 'Visit the official residence of the Kings of Siam.',
        'price': '฿500',
        'rating': 4.8,
        'reviews': 3500,
        'duration': '3 hours',
        'image': 'assets/images/bangkok.jpg',
        'location': 'Phra Nakhon',
        'difficulty': 'Moderate',
        'isSaved': false,
      },
    ];

    // ISTANBUL ACTIVITIES
    final istanbulActivities = [
       {
        'cityId': 'istanbul',
        'name': 'Hagia Sophia Visit',
        'category': 'Culture',
        'description': 'Explore the world-famous historic site.',
        'price': 'Free',
        'rating': 4.9,
        'reviews': 7000,
        'duration': '2 hours',
        'image': 'assets/images/istanbul.jpg',
        'location': 'Sultanahmet',
        'difficulty': 'Easy',
        'isSaved': false,
      },
    ];

    // Add Paris Items
    for (var doc in parisActivities) {
      final docRef = _firestore.collection('activities').doc(); 
      batch.set(docRef, doc);
    }

    // Add Lahore Items
    for (var doc in lahoreActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }
    
    // Add Dubai Items
    for (var doc in dubaiActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }
    
    // Add London Items
    for (var doc in londonActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }

    // Add Karachi Items
    for (var doc in karachiActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }

     // Add New York Items
    for (var doc in newYorkActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }

    // Add Bangkok Items
    for (var doc in bangkokActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }

    // Add Istanbul Items
    for (var doc in istanbulActivities) {
      final docRef = _firestore.collection('activities').doc();
      batch.set(docRef, doc);
    }

    await batch.commit();
    print('Seeding completed successfully!');
  }
  
  // Keep existing methods if any, usually seeder is simpler
  Future<void> seedTouristSpots() async {}
  Future<void> seedHotels() async {}
}
