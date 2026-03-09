import 'package:cloud_firestore/cloud_firestore.dart';

class MapService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllPlaces() {
    return _db.collection('places').snapshots();
  }

  Stream<QuerySnapshot> getPreviewPlaces() {
    return _db.collection('places').limit(5).snapshots();
  }
}