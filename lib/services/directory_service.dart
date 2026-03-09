import 'package:cloud_firestore/cloud_firestore.dart';

class DirectoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Handles both Category and Search Query
  Stream<QuerySnapshot> getPlaces({String? query, String? category}) {
    Query placesQuery = _db.collection('places');

    // 1. Filter by Category first
    if (category != null && category != "All Places") {
      placesQuery = placesQuery.where('category', isEqualTo: category);
    }

    // 2. Apply Search Filter
    if (query != null && query.isNotEmpty) {
      placesQuery = placesQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff');
    }

    return placesQuery.snapshots();
  }

  // THE SEED FUNCTION
  Future<void> seedKigaliData() async {
    var existing = await _db.collection('places').get();
    for (var doc in existing.docs) {
      await doc.reference.delete();
    }

    final List<Map<String, dynamic>> kigaliPlaces = [
      {
        "title": "Kigali Heights",
        "category": "Cafés & Dining",
        "location": "KG 7 Ave, Kimihurura",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/kigali-heights_vcjy1u.webp",
      },
      {
        "title": "King Faisal Hospital",
        "category": "Hospitals",
        "location": "KG 544 St, Kacyiru",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/king-faisal_bbadnv.webp",
      },
      {
        "title": "I&M Bank Headquarters",
        "category": "Banks",
        "location": "KN 3 Ave, City Center",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/i_M_atw9iv.webp",
      },
      {
        "title": "Kigali Public Library",
        "category": "Public Services",
        "location": "KG 8 Ave, Kacyiru",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/library_wok6d7.webp",
      },
      {
        "title": "Inzora Rooftop Café",
        "category": "Cafés & Dining",
        "location": "KG 5 Ave, Kacyiru",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/inzora-rooftop-cafe_qtviwv.webp",
      },
      {
        "title": "CHUK Hospital",
        "category": "Hospitals",
        "location": "KN 4 Ave, Nyarugenge",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/CHUK_rd8afq.webp",
      },
      {
        "title": "BK Arena",
        "category": "Public Services",
        "location": "KG 17 Ave, Remera",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/bk_arena_m3vuvg.webp",
      },
      {
        "title": "Question Coffee",
        "category": "Cafés & Dining",
        "location": "KG 8 Ave, Gishushu",
        "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
      },
      {
        "title": "EcoBank Rwanda",
        "category": "Banks",
        "location": "KN 3 Rd, Nyarugenge",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/ecobank_bhh4g2.webp",
      },
      {
        "title": "Kipharma",
        "category": "Pharmacies",
        "location": "KN 4 Ave, City Center",
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/kipharma_ifxdzc.webp",
      }
    ];

    for (var place in kigaliPlaces) {
      await _db.collection('places').add(place);
    }
    print("Kigali Directory Seeded Successfully!");
  }
}