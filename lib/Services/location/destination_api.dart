import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DestinationApi {
  static Future<List<String>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5'
        ),
        headers: {'User-Agent': 'TravelMateApp/1.0'}, // Required by Nominatim
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<String>((place) {
          return place['display_name'] as String;
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}