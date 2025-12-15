import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelmate/Services/API/MockData.dart';

class AmadeusApiService {
  // Replace with your credentials or leave as is to trigger Mock Mode
  final String _apiKey = 'YOUR_API_KEY_HERE';
  final String _apiSecret = 'YOUR_API_SECRET_HERE';
  final String _baseUrl =
      'https://test.api.amadeus.com/v1'; // v1 or v2 depending on endpoint

  String? _accessToken;
  DateTime? _tokenExpiry;
  bool _useMock = false; // Flag to switch to mock data on error

  // Singleton pattern
  static final AmadeusApiService _instance = AmadeusApiService._internal();
  factory AmadeusApiService() => _instance;
  AmadeusApiService._internal();

  /// Authenticate with Amadeus API
  Future<String> _getAccessToken() async {
    // If we're already in mock mode, return valid-looking token
    if (_useMock) return 'mock_token';

    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    // Check for placeholder credentials
    if (_apiKey == 'YOUR_API_KEY_HERE' ||
        _apiSecret == 'YOUR_API_SECRET_HERE') {
      print('Using Mock Data (Credentials missing)');
      _useMock = true;
      return 'mock_token';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/security/oauth2/token'),
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
        _tokenExpiry = DateTime.now().add(
          Duration(seconds: data['expires_in']),
        );
        _useMock = false; // Connection successful
        return _accessToken!;
      } else {
        print('Amadeus Auth Failed: ${response.body}');
        // Fallback to mock on auth failure
        _useMock = true;
        return 'mock_token';
      }
    } catch (e) {
      print('Amadeus Connection Error: $e');
      _useMock = true;
      return 'mock_token';
    }
  }

  // ================= SEARCH METHODS =================

  /// Search Flights
  Future<List<Map<String, dynamic>>> searchFlights({
    required String originCode,
    required String destinationCode,
    required String departureDate,
    int adults = 1,
  }) async {
    try {
      final token = await _getAccessToken();

      if (_useMock) {
        await Future.delayed(const Duration(seconds: 1));
        // Dynamic Mock Generation based on query
        return _generateMockFlights(originCode, destinationCode, departureDate);
      }

      final uri = Uri.parse('$_baseUrl/v2/shopping/flight-offers').replace(
        queryParameters: {
          'originLocationCode': originCode,
          'destinationLocationCode': destinationCode,
          'departureDate': departureDate,
          'adults': adults.toString(),
          'max': '5',
        },
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List offers = data['data'] ?? [];
        return offers.map((offer) => _normalizeFlight(offer)).toList();
      } else {
        throw Exception('Failed to search flights');
      }
    } catch (e) {
      if (_useMock)
        return _generateMockFlights(originCode, destinationCode, departureDate);
      print('Flight Search Error: $e');
      _useMock = true; // Switch to mock on error
      return _generateMockFlights(originCode, destinationCode, departureDate);
    }
  }

  /// Search Hotels
  Future<List<Map<String, dynamic>>> searchHotels({
    required String cityCode,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
  }) async {
    try {
      final token = await _getAccessToken();

      if (_useMock) {
        await Future.delayed(const Duration(seconds: 1));
        return _generateMockHotels(cityCode);
      }

      final uri =
          Uri.parse(
            '$_baseUrl/v1/reference-data/locations/hotels/by-city',
          ).replace(
            queryParameters: {
              'cityCode': cityCode,
              'radius': '10',
              'radiusUnit': 'KM',
              // Note: Full hotel pricing requires another endpoint in production (Hotel Search v3),
              // but for this demo we might use simple list or normalized data
            },
          );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List hotels = data['data'] ?? [];
        // For 'by-city' endpoint, we don't get prices. We mock prices for the UI.
        return hotels.take(5).map((h) => _normalizeHotel(h)).toList();
      } else {
        throw Exception('Failed to search hotels');
      }
    } catch (e) {
      if (_useMock) return _generateMockHotels(cityCode);
      // Check if error is 401 or 500, then switch to mock
      _useMock = true;
      return _generateMockHotels(cityCode);
    }
  }

  /// Search Activities
  Future<List<Map<String, dynamic>>> searchActivities({
    required double latitude,
    required double longitude,
    int radius = 5,
  }) async {
    try {
      final token = await _getAccessToken();

      if (_useMock) {
        await Future.delayed(const Duration(seconds: 1));
        return _generateMockActivities(latitude, longitude);
      }

      final uri = Uri.parse('$_baseUrl/v1/shopping/activities').replace(
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'radius': radius.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List activities = data['data'] ?? [];
        return activities.map((a) => _normalizeActivity(a)).toList();
      } else {
        throw Exception('Failed to search activities');
      }
    } catch (e) {
      _useMock = true;
      return _generateMockActivities(latitude, longitude);
    }
  }

  /// Search Locations (Cities/Airports)
  Future<List<Map<String, dynamic>>> searchLocations(String keyword) async {
    try {
      final token = await _getAccessToken();

      if (_useMock) {
        return _searchMockLocations(keyword);
      }

      final uri = Uri.parse('$_baseUrl/v1/reference-data/locations').replace(
        queryParameters: {'keyword': keyword, 'subType': 'CITY,AIRPORT'},
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List locations = data['data'] ?? [];
        return locations.map((l) => _normalizeLocation(l)).toList();
      } else {
        throw Exception('Failed to search locations');
      }
    } catch (e) {
      _useMock = true;
      return _searchMockLocations(keyword);
    }
  }

  // ================= NORMALIZERS =================

  Map<String, dynamic> _normalizeFlight(Map<String, dynamic> flight) {
    // Extract relevant data from complex Amadeus response
    // Heavily simplified
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
      'price': {
        'total': flight['price']['total'],
        'currency': flight['price']['currency'],
      },
    };
  }

  Map<String, dynamic> _normalizeHotel(Map<String, dynamic> hotel) {
    return {
      'hotelId': hotel['hotelId'] ?? 'unknown',
      'name': hotel['name'] ?? 'Unknown Hotel',
      'rating': hotel['rating'] ?? '4.0',
      'location': hotel['address'] ?? {},
      'price': {'total': '150.00', 'currency': 'USD'}, // Simulated price
      'amenities': ['WIFI', 'POOL'], // Simulated
    };
  }

  Map<String, dynamic> _normalizeActivity(Map<String, dynamic> activity) {
    return {
      'id': activity['id'],
      'name': activity['name'],
      'description': activity['shortDescription'] ?? 'No description',
      'category': activity['type'] ?? 'General',
      'location': activity['geoCode'],
      'price': {
        'amount': activity['price']?['amount'] ?? '50.00',
        'currency': activity['price']?['currencyCode'] ?? 'USD',
      },
      'rating': activity['rating'] ?? '4.5',
      'images': activity['pictures'] ?? [],
    };
  }

  Map<String, dynamic> _normalizeLocation(Map<String, dynamic> loc) {
    return {
      'code': loc['iataCode'],
      'name': loc['name'],
      'city': loc['address']['cityName'],
      'country': loc['address']['countryName'],
      'type': loc['subType'],
      'geoCode': loc['geoCode'], // Includes latitude/longitude if available
    };
  }

  // ================= DYNAMIC MOCK GENERATORS =================

  List<Map<String, dynamic>> _generateMockFlights(
    String origin,
    String dest,
    String date,
  ) {
    return [
      {
        'id': 'mock-1',
        'airline': 'MockAir',
        'flightNumber': '101',
        'departure': {'airport': origin, 'time': '${date}T10:00:00'},
        'arrival': {'airport': dest, 'time': '${date}T14:30:00'},
        'duration': 'PT4H30M',
        'price': {'total': '350.00', 'currency': 'USD'},
        'stops': 0,
      },
      {
        'id': 'mock-2',
        'airline': 'AirDemo',
        'flightNumber': '220',
        'departure': {'airport': origin, 'time': '${date}T16:00:00'},
        'arrival': {'airport': dest, 'time': '${date}T20:45:00'},
        'duration': 'PT4H45M',
        'price': {'total': '320.00', 'currency': 'USD'},
        'stops': 1,
      },
      {
        'id': 'mock-3',
        'airline': 'JetStream',
        'flightNumber': '888',
        'departure': {'airport': origin, 'time': '${date}T08:00:00'},
        'arrival': {'airport': dest, 'time': '${date}T12:00:00'},
        'duration': 'PT4H00M',
        'price': {'total': '450.00', 'currency': 'USD'},
        'stops': 0,
      },
    ];
  }

  List<Map<String, dynamic>> _generateMockHotels(String cityCode) {
    return [
      {
        'hotelId': 'h1',
        'name': 'Grand Hotel $cityCode',
        'rating': '4.5',
        'price': {'total': '150.00', 'currency': 'USD'},
        'offers': [
          {
            'price': {'total': '150.00', 'currency': 'USD'},
            'room': {'type': 'Deluxe'},
          },
        ],
      },
      {
        'hotelId': 'h2',
        'name': '$cityCode City Resort',
        'rating': '4.8',
        'price': {'total': '220.00', 'currency': 'USD'},
        'offers': [
          {
            'price': {'total': '220.00', 'currency': 'USD'},
            'room': {'type': 'Suite'},
          },
        ],
      },
      {
        'hotelId': 'h3',
        'name': 'Budget Inn $cityCode',
        'rating': '3.9',
        'price': {'total': '80.00', 'currency': 'USD'},
        'offers': [
          {
            'price': {'total': '80.00', 'currency': 'USD'},
            'room': {'type': 'Standard'},
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _generateMockActivities(double lat, double lng) {
    return [
      {
        'id': 'a1',
        'name': 'City Tour',
        'description': 'Guided tour of the city highlights.',
        'type': 'TOUR',
        'price': {'amount': '40.00', 'currencyCode': 'USD'},
        'rating': '4.7',
        'geoCode': {'latitude': lat, 'longitude': lng},
        'pictures': ['https://example.com/tour.jpg'],
      },
      {
        'id': 'a2',
        'name': 'Museum Visit',
        'description': 'Entry to the national museum.',
        'type': 'CULTURE',
        'price': {'amount': '25.00', 'currencyCode': 'USD'},
        'rating': '4.5',
        'geoCode': {'latitude': lat, 'longitude': lng},
        'pictures': ['https://example.com/museum.jpg'],
      },
      {
        'id': 'a3',
        'name': 'Food Tasting',
        'description': 'Taste local delicacies.',
        'type': 'FOOD',
        'price': {'amount': '60.00', 'currencyCode': 'USD'},
        'rating': '4.9',
        'geoCode': {'latitude': lat, 'longitude': lng},
        'pictures': ['https://example.com/food.jpg'],
      },
    ];
  }

  List<Map<String, dynamic>> _searchMockLocations(String keyword) {
    // Find in static mock data first
    final staticMatches = MockData.locations
        .where(
          (l) =>
              l['name'].toString().toLowerCase().contains(
                keyword.toLowerCase(),
              ) ||
              l['iataCode'].toString().toLowerCase().contains(
                keyword.toLowerCase(),
              ) ||
              l['address']['cityName'].toString().toLowerCase().contains(
                (keyword.toLowerCase()),
              ),
        )
        .toList();

    if (staticMatches.isNotEmpty) {
      return staticMatches
          .map(
            (l) => {
              'code': l['iataCode'],
              'name': l['name'],
              'city': l['address']['cityName'],
              'country': l['address']['countryName'],
              'type': l['subType'],
              // Add default coords if missing in static data
              'geoCode':
                  l['geoCode'] ?? {'latitude': 48.8566, 'longitude': 2.3522},
            },
          )
          .toList();
    }

    // If no static match, generate a dynamic one to ensure flow works
    return [
      {
        'code': keyword.substring(0, 3).toUpperCase(),
        'name': keyword,
        'city': keyword,
        'country': 'Mock Country',
        'type': 'CITY',
        'geoCode': {'latitude': 48.8566, 'longitude': 2.3522},
      },
    ];
  }

  // Helper for Packages (Keep existing logic)
  Future<Map<String, dynamic>> createPackage({
    required Map<String, dynamic> flight,
    required Map<String, dynamic> hotel,
  }) async {
    final flightPrice =
        double.tryParse(flight['price']['total'].toString()) ?? 0.0;
    final hotelPrice =
        double.tryParse(hotel['price']['total'].toString()) ?? 0.0;
    final total = flightPrice + hotelPrice;
    final savings = total * 0.15;
    return {
      'id': 'PKG-${flight['id']}',
      'type': 'Package',
      'flight': flight,
      'hotel': hotel,
      'price': {
        'total': total,
        'discount': savings,
        'finalPrice': total - savings,
        'currency': 'USD',
      },
      'savings': '15%',
    };
  }
}
