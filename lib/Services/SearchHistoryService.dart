import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'recent_searches';

  // Get all searches
  Future<List<Map<String, String>>> getSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }

  // Add a new search
  Future<void> addSearch(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> searches = await getSearches();

    // Remove duplicates (optional: move to top if exists)
    searches.removeWhere((item) => 
        item['from']?.toLowerCase() == from.toLowerCase() && 
        item['to']?.toLowerCase() == to.toLowerCase()
    );

    // Add to top
    searches.insert(0, {'from': from, 'to': to});

    // Limit to 5
    if (searches.length > 5) {
      searches = searches.sublist(0, 5);
    }

    await prefs.setString(_key, jsonEncode(searches));
  }

  // Clear all searches
  Future<void> clearSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // Delete specific search (by index)
  Future<void> deleteSearch(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> searches = await getSearches();

    if (index >= 0 && index < searches.length) {
      searches.removeAt(index);
      await prefs.setString(_key, jsonEncode(searches));
    }
  }
}
