import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'places';

  Future<void> addListing(Map<String, dynamic> data) async {
    try {
      final User? user = _auth.currentUser;
      await _db.collection(collection).add({
        ...data,
        'createdBy': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add listing: $e");
    }
  }

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

  Future<void> deleteListing(String docId) async {
    try {
      await _db.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete listing: $e");
    }
  }

  Stream<QuerySnapshot> getMyListings() {
    final User? user = _auth.currentUser;
    return _db
        .collection(collection)
        .where('createdBy', isEqualTo: user?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}