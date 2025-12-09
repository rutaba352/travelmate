import 'dart:async';

class DestinationApi {
  static Future<List<String>> getCitySuggestions(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock data - you can replace with real API later
    final allCities = [
      "Paris, France",
      "Tokyo, Japan",
      "London, UK",
      "New York, USA",
      "Bangkok, Thailand",
      "Dubai, UAE",
      "Singapore",
      "Sydney, Australia",
      "Rome, Italy",
      "Barcelona, Spain",
      "Istanbul, Turkey",
      "Bali, Indonesia",
      "Switzerland, Europe",
      "Iceland, Nordic",
      "Cancun, Mexico",
      "Maldives",
      "Amsterdam, Netherlands",
      "Barcelona, Spain",
      "Vienna, Austria",
      "Prague, Czech Republic"
    ];

    return allCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}