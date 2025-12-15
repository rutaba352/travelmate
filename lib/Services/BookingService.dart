import 'package:travelmate/Services/SavedItemsService.dart';

/// BookingService wrapper to satisfy project architecture requirements
/// Delegates actual storage to SavedItemsService
class BookingService {
  final SavedItemsService _savedItemsService = SavedItemsService();

  // Singleton
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  /// Create a new booking
  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    return _savedItemsService.bookItem(bookingData);
  }

  /// Get user bookings
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    return _savedItemsService.getBookings();
  }
}
