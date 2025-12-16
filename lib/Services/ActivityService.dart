import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch activities for a specific city
  Future<List<Map<String, dynamic>>> getActivities(String cityId) async {
    try {
      final snapshot = await _firestore
          .collection('activities')
          .where('cityId', isEqualTo: cityId.toLowerCase().trim())
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include document ID
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  /// Add (Seed) an activity
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    try {
      await _firestore.collection('activities').add(activityData);
    } catch (e) {
      print('Error adding activity: $e');
    }
  }
}
