import 'package:cloud_firestore/cloud_firestore.dart';

class DirectoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Search places by title using the "Prefix" trick
  Stream<QuerySnapshot> searchPlaces(String query) {
    // Reference the 'places' collection
    Query placesQuery = _db.collection('places');

    if (query.isNotEmpty) {
      // Normalize to match database casing
      placesQuery = placesQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff');
    }

    return placesQuery.snapshots();
  }
}