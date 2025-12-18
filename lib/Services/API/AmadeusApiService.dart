import 'dart:convert';
import 'package:http/http.dart' as http;

/// Amadeus API Service for TravelMate
/// Free API for flights, hotels, and activities
/// Sign up at: https://developers.amadeus.com/register
class AmadeusApiService {
  // ⚠️ IMPORTANT: Replace these with your own credentials from Amadeus
  // Get them FREE at: https://developers.amadeus.com/register
  static const String _apiKey = 'Qrqd9Z1dZjOuksAVPg4X6fHHnXZNTp5V';
  static const String _apiSecret = 'drmPxGHAunKpg1qp';

  static const String _baseUrl = 'https://test.api.amadeus.com';
  String? _accessToken;
  DateTime? _tokenExpiry;

  // Singleton pattern
  static final AmadeusApiService _instance = AmadeusApiService._internal();
  factory AmadeusApiService() => _instance;
  AmadeusApiService._internal();

  /// Get access token (expires every 30 minutes)
  Future<String> _getAccessToken() async {
    // Check if token is still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/security/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'client_credentials',
          'client_id': _apiKey,
          'client_secret': _apiSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        // Token expires in 30 minutes, set expiry to 25 minutes for safety
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 25));
        return _accessToken!;
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Authentication error: $e');
    }
  }

  /// Search Flights
  /// Example: from = 'NYC', to = 'PAR', date = '2024-12-20'
  Future<List<Map<String, dynamic>>> searchFlights({
    required String originCode,
    required String destinationCode,
    required String departureDate,
    int adults = 1,
    String? returnDate,
  }) async {
    try {
      final token = await _getAccessToken();

      final queryParams = {
        'originLocationCode': originCode,
        'destinationLocationCode': destinationCode,
        'departureDate': departureDate,
        'adults': adults.toString(),
        'max': '20', // Limit results
      };

      if (returnDate != null) {
        queryParams['returnDate'] = returnDate;
      }

      final uri = Uri.parse('$_baseUrl/v2/shopping/flight-offers')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List flights = data['data'] ?? [];

        return flights.map((flight) {
          final itinerary = flight['itineraries'][0];
          final segment = itinerary['segments'][0];

          return {
            'id': flight['id'],
            'airline': segment['carrierCode'],
            'flightNumber': segment['number'],
            'departure': {
              'airport': segment['departure']['iataCode'],
              'time': segment['departure']['at'],
            },
            'arrival': {
              'airport': segment['arrival']['iataCode'],
              'time': segment['arrival']['at'],
            },
            'duration': itinerary['duration'],
            'stops': itinerary['segments'].length - 1,
            'price': {
              'total': flight['price']['total'],
              'currency': flight['price']['currency'],
            },
            'seats': flight['numberOfBookableSeats'],
          };
        }).toList();
      } else {
        throw Exception('Failed to search flights: ${response.body}');
      }
    } catch (e) {
      throw Exception('Flight search error: $e');
    }
  }

  /// Search Hotels by City
  /// Example: cityCode = 'PAR' (Paris), checkIn = '2024-12-20', checkOut = '2024-12-25'
  Future<List<Map<String, dynamic>>> searchHotels({
    required String cityCode,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
  }) async {
    try {
      final token = await _getAccessToken();

      // Step 1: Get hotel IDs in the city
      final hotelsUri = Uri.parse('$_baseUrl/v1/reference-data/locations/hotels/by-city')
          .replace(queryParameters: {'cityCode': cityCode});

      final hotelsResponse = await http.get(
        hotelsUri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (hotelsResponse.statusCode != 200) {
        throw Exception('Failed to get hotels');
      }

      final hotelsData = json.decode(hotelsResponse.body);
      final List hotels = hotelsData['data'] ?? [];

      if (hotels.isEmpty) return [];

      // Get first 10 hotel IDs
      final hotelIds = hotels.take(10).map((h) => h['hotelId']).join(',');

      // Step 2: Get hotel offers with prices
      final offersUri = Uri.parse('$_baseUrl/v3/shopping/hotel-offers')
          .replace(queryParameters: {
        'hotelIds': hotelIds,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'adults': adults.toString(),
      });

      final offersResponse = await http.get(
        offersUri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (offersResponse.statusCode == 200) {
        final offersData = json.decode(offersResponse.body);
        final List offers = offersData['data'] ?? [];

        return offers.map((offer) {
          final hotel = offer['hotel'];
          final bestOffer = offer['offers'][0];

          return {
            'id': hotel['hotelId'],
            'name': hotel['name'],
            'rating': hotel['rating'] ?? 'N/A',
            'location': {
              'latitude': hotel['latitude'],
              'longitude': hotel['longitude'],
              'cityCode': cityCode,
            },
            'price': {
              'total': bestOffer['price']['total'],
              'currency': bestOffer['price']['currency'],
              'perNight': (double.parse(bestOffer['price']['total']) /
                  _calculateNights(checkInDate, checkOutDate)).toStringAsFixed(2),
            },
            'roomType': bestOffer['room']['type'],
            'amenities': hotel['amenities'] ?? [],
            'checkIn': checkInDate,
            'checkOut': checkOutDate,
          };
        }).toList();
      } else {
        throw Exception('Failed to get hotel offers');
      }
    } catch (e) {
      throw Exception('Hotel search error: $e');
    }
  }

  /// Search Points of Interest (Tourist Attractions)
  /// Example: latitude = 48.8566, longitude = 2.3522 (Paris)
  Future<List<Map<String, dynamic>>> searchActivities({
    required double latitude,
    required double longitude,
    int radius = 5, // km
  }) async {
    try {
      final token = await _getAccessToken();

      final uri = Uri.parse('$_baseUrl/v1/shopping/activities')
          .replace(queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
      });

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List activities = data['data'] ?? [];

        return activities.map((activity) {
          return {
            'id': activity['id'],
            'name': activity['name'],
            'description': activity['shortDescription'] ?? 'No description available',
            'category': activity['type'] ?? 'General',
            'location': {
              'latitude': activity['geoCode']['latitude'],
              'longitude': activity['geoCode']['longitude'],
            },
            'price': {
              'amount': activity['price']['amount'],
              'currency': activity['price']['currencyCode'],
            },
            'rating': activity['rating'] ?? 'N/A',
            'images': activity['pictures'] ?? [],
          };
        }).toList();
      } else {
        throw Exception('Failed to search activities');
      }
    } catch (e) {
      throw Exception('Activities search error: $e');
    }
  }

  /// Get City/Airport code from name
  /// Example: 'Paris' -> 'PAR', 'New York' -> 'NYC'
  Future<List<Map<String, dynamic>>> searchLocations(String keyword) async {
    try {
      final token = await _getAccessToken();

      final uri = Uri.parse('$_baseUrl/v1/reference-data/locations')
          .replace(queryParameters: {
        'keyword': keyword,
        'subType': 'CITY,AIRPORT',
      });

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List locations = data['data'] ?? [];

        return locations.map((location) {
          return {
            'code': location['iataCode'],
            'name': location['name'],
            'city': location['address']['cityName'],
            'country': location['address']['countryName'],
            'type': location['subType'], // CITY or AIRPORT
          };
        }).toList();
      } else {
        throw Exception('Failed to search locations');
      }
    } catch (e) {
      throw Exception('Location search error: $e');
    }
  }

  /// Helper: Calculate nights between dates
  int _calculateNights(String checkIn, String checkOut) {
    final checkInDate = DateTime.parse(checkIn);
    final checkOutDate = DateTime.parse(checkOut);
    return checkOutDate.difference(checkInDate).inDays;
  }

  /// Create Package (Flight + Hotel combination)
  Future<Map<String, dynamic>> createPackage({
    required Map<String, dynamic> flight,
    required Map<String, dynamic> hotel,
  }) async {
    final flightPrice = double.parse(flight['price']['total']);
    final hotelPrice = double.parse(hotel['price']['total']);
    final totalPrice = flightPrice + hotelPrice;
    final savings = totalPrice * 0.15; // 15% package discount

    return {
      'id': 'PKG-${flight['id']}-${hotel['id']}',
      'type': 'Package',
      'flight': flight,
      'hotel': hotel,
      'price': {
        'flight': flightPrice,
        'hotel': hotelPrice,
        'total': totalPrice,
        'discount': savings,
        'finalPrice': totalPrice - savings,
        'currency': flight['price']['currency'],
      },
      'duration': '${_calculateNights(hotel['checkIn'], hotel['checkOut'])} Days',
      'savings': '${((savings / totalPrice) * 100).toStringAsFixed(0)}%',
    };
  }
}
