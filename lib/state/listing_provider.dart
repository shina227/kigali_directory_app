import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_directory_app/services/listing_service.dart';
import 'package:kigali_directory_app/services/directory_service.dart';

class ListingProvider extends ChangeNotifier {
  final ListingService _listingService = ListingService();
  final DirectoryService _directoryService = DirectoryService();

  List<Map<String, dynamic>> _allListings = [];
  List<Map<String, dynamic>> _myListings = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get allListings => _allListings;
  List<Map<String, dynamic>> get myListings => _myListings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Listen to all places (Directory screen)
  void listenToAllListings({String? category}) {
    _setLoading(true);
    _directoryService
        .getPlaces(category: category)
        .listen((snapshot) {
      _allListings = snapshot.docs
          .map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'docId': doc.id,
      })
          .toList();
      _setLoading(false);
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
    });
  }

  // Listen to current user's listings (My Listings screen)
  void listenToMyListings() {
    _setLoading(true);
    _listingService.getMyListings().listen((snapshot) {
      _myListings = snapshot.docs
          .map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'docId': doc.id,
      })
          .toList();
      _setLoading(false);
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
    });
  }

  // Create
  Future<void> addListing(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _listingService.addListing(data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update
  Future<void> updateListing(
      String docId, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _listingService.updateListing(docId, data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Delete
  Future<void> deleteListing(String docId) async {
    _setLoading(true);
    try {
      await _listingService.deleteListing(docId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}