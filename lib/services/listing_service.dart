import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'places';

  // --- Create ---
  Future<void> addListing(Map<String, dynamic> data) async {
    try {
      final User? user = _auth.currentUser;
      await _db.collection(collection).add({
        ...data,
        'userId': user?.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add listing: $e");
    }
  }

  // --- Update ---
  Future<void> updateListing(String docId, Map<String, dynamic> newData) async {
    try {
      await _db.collection(collection).doc(docId).update({
        ...newData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to update listing: $e");
    }
  }

  // --- Delete ---
  Future<void> deleteListing(String docId) async {
    try {
      await _db.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete listing: $e");
    }
  }

  // --- Read (Optional Helper) ---
  // Returns a stream of listings specific to the logged-in user
  Stream<QuerySnapshot> getMyListings() {
    final User? user = _auth.currentUser;
    return _db
        .collection(collection)
        .where('userId', isEqualTo: user?.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}