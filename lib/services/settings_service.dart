import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  String get _collection => "users";

  // Save or Update User Preferences & Profile Info
  Future<void> updateUserSettings(Map<String, dynamic> settingsData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection(_collection).doc(user.uid).set(
        {
          ...settingsData,
          "lastUpdated": FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true), // Use merge to avoid overwriting existing fields
      );
    } catch (e) {
      throw Exception("Failed to update settings: $e");
    }
  }

  // Stream user data to keep the UI in sync
  Stream<DocumentSnapshot> getUserSettings() {
    final user = _auth.currentUser;
    return _db.collection(_collection).doc(user?.uid).snapshots();
  }
}