import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for managing saved/favorite items and bookings
class SavedItemsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final SavedItemsService _instance = SavedItemsService._internal();
  factory SavedItemsService() => _instance;
  SavedItemsService._internal();

  /// Get current user ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Get reference to user's saved items collection
  CollectionReference? get _savedItemsRef {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId).collection('savedItems');
  }

  /// Get reference to user's bookings collection
  CollectionReference? get _bookingsRef {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId).collection('bookings');
  }

  // ================= SAVED ITEMS =================

  /// Save an item to favorites
  // Stream for Real-time Updates
  Stream<List<Map<String, dynamic>>> getSavedItemsStream() {
    if (_savedItemsRef == null) return Stream.value([]);
    return _savedItemsRef!.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getBookingsStream() {
    if (_bookingsRef == null) return Stream.value([]);
    return _bookingsRef!.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<bool> saveItem(Map<String, dynamic> item) async {
    if (_savedItemsRef == null) return false;

    try {
      final itemId = _generateItemId(item);
      await _savedItemsRef!.doc(itemId).set({
        ...item,
        'savedAt': FieldValue.serverTimestamp(),
        'itemId': itemId,
      });
      return true;
    } catch (e) {
      print('Error saving item: $e');
      return false;
    }
  }

  /// Remove an item from favorites
  Future<bool> removeItem(String itemId) async {
    if (_savedItemsRef == null) return false;

    try {
      await _savedItemsRef!.doc(itemId).delete();
      return true;
    } catch (e) {
      print('Error removing item: $e');
      return false;
    }
  }

  /// Get all saved items
  Future<List<Map<String, dynamic>>> getSavedItems() async {
    if (_savedItemsRef == null) return [];

    try {
      final snapshot = await _savedItemsRef!
          .orderBy('savedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'itemId': doc.id};
      }).toList();
    } catch (e) {
      print('Error getting saved items: $e');
      return [];
    }
  }

  /// Check if an item is saved
  Future<bool> isItemSaved(String itemId) async {
    if (_savedItemsRef == null) return false;
    try {
      final doc = await _savedItemsRef!.doc(itemId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get count of saved items
  Future<int> getSavedItemsCount() async {
    if (_savedItemsRef == null) return 0;
    try {
      final snapshot = await _savedItemsRef!.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ================= BOOKINGS =================

  /// Book an item (Add to My Trips)
  Future<bool> bookItem(Map<String, dynamic> item) async {
    if (_bookingsRef == null) return false;

    try {
      final itemId =
          _generateItemId(item) + '_booking'; // Distinct from saved ID
      await _bookingsRef!.doc(itemId).set({
        ...item,
        'bookedAt': FieldValue.serverTimestamp(),
        'status': 'Upcoming',
        'itemId': itemId,
        'startDate': item['startDate'] ??
            _formatDate(DateTime.now()), // Respect passed date
        'endDate': item['endDate'] ??
            _formatDate(DateTime.now().add(const Duration(days: 7))),
      });
      return true;
    } catch (e) {
      print('Error booking item: $e');
      return false;
    }
  }

  /// Remove a booking
  Future<bool> removeBooking(String itemId) async {
    if (_bookingsRef == null) return false;
    try {
      await _bookingsRef!.doc(itemId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get all bookings
  Future<List<Map<String, dynamic>>> getBookings() async {
    if (_bookingsRef == null) return [];

    try {
      final snapshot = await _bookingsRef!
          .orderBy('bookedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'itemId': doc.id};
      }).toList();
    } catch (e) {
      print('Error getting bookings: $e');
      return [];
    }
  }

  /// Get count of bookings
  Future<int> getBookingsCount() async {
    if (_bookingsRef == null) return 0;
    try {
      final snapshot = await _bookingsRef!.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ================= HELPERS =================

  /// Generate ID
  String _generateItemId(Map<String, dynamic> item) {
    final name = (item['name'] ?? item['title'] ?? 'unknown')
        .toString()
        .toLowerCase()
        .replaceAll(' ', '_');
    final category = (item['category'] ?? 'general').toString().toLowerCase();
    return '${category}_$name'.replaceAll(RegExp(r'[^\w]'), '_');
  }

  String _formatDate(DateTime date) {
    // Simple format MMM d, yyyy
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Wrappers for specific types
  Future<bool> saveDestination(Map<String, dynamic> destination) =>
      saveItem(_normalizeDestination(destination));
  Future<bool> bookDestination(Map<String, dynamic> destination) =>
      bookItem(_normalizeDestination(destination));

  Future<bool> saveFlight(Map<String, dynamic> flight) =>
      saveItem(_normalizeFlight(flight));
  Future<bool> bookFlight(Map<String, dynamic> flight) =>
      bookItem(_normalizeFlight(flight));

  Future<bool> saveHotel(Map<String, dynamic> hotel) =>
      saveItem(_normalizeHotel(hotel));
  Future<bool> bookHotel(Map<String, dynamic> hotel) =>
      bookItem(_normalizeHotel(hotel));

  Future<bool> saveActivity(Map<String, dynamic> activity) =>
      saveItem(_normalizeActivity(activity));
  Future<bool> bookActivity(Map<String, dynamic> activity) =>
      bookItem(_normalizeActivity(activity));

  Map<String, dynamic> _normalizeDestination(Map<String, dynamic> data) => {
    'title': data['name'],
    'name': data['name'],
    'location': data['country'],
    'category': 'Places',
    'image': data['image'] ?? '🌍',
    'rating': data['rating'],
    'price': data['price'],
    'type': 'destination',
  };

  Map<String, dynamic> _normalizeFlight(Map<String, dynamic> data) => {
    'title': '${data['airline']} ${data['flightNumber']}',
    'name': '${data['departure']['airport']} → ${data['arrival']['airport']}',
    'location': 'Flight',
    'category': 'Flights',
    'image': '✈️',
    'rating': 'N/A',
    'price': '${data['price']['currency']} ${data['price']['total']}',
    'type': 'flight',
  };

  Map<String, dynamic> _normalizeHotel(Map<String, dynamic> data) => {
    'title': data['name'],
    'name': data['name'],
    'location': data['location']?['cityCode'] ?? 'Hotel',
    'category': 'Hotels',
    'image': '🏨',
    'rating': data['rating']?.toString() ?? 'N/A',
    'price': '${data['price']['currency']} ${data['price']['total']}',
    'type': 'hotel',
  };

  Map<String, dynamic> _normalizeActivity(Map<String, dynamic> data) => {
    'title': data['name'],
    'name': data['name'],
    'location': data['category'] ?? 'Activity',
    'category': 'Activities',
    'image': '🎯',
    'rating': data['rating']?.toString() ?? 'N/A',
    'price': '${data['price']['currency']} ${data['price']['amount']}',
    'type': 'activity',
  };
}
