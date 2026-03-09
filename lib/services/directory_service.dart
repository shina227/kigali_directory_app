import 'package:cloud_firestore/cloud_firestore.dart';

class DirectoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Search and Filter
  Stream<QuerySnapshot> getPlaces({String? query, String? category}) {
    Query placesQuery = _db.collection('places').orderBy('timestamp', descending: true);

    if (category != null && category != "All Places") {
      placesQuery = placesQuery.where('category', isEqualTo: category);
    }

    return placesQuery.snapshots();
  }

  // The seed function
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
        "contact": "+250 788 000 001",
        "description": "A premier mixed-use development featuring top restaurants, cafés, and offices in the heart of Kigali.",
        "latitude": -1.9441,
        "longitude": 30.0619,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/kigali-heights_vcjy1u.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "King Faisal Hospital",
        "category": "Hospitals",
        "location": "KG 544 St, Kacyiru",
        "contact": "+250 788 000 002",
        "description": "One of Rwanda's leading referral hospitals providing specialized medical care.",
        "latitude": -1.9355,
        "longitude": 30.0928,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/king-faisal_bbadnv.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "I&M Bank Headquarters",
        "category": "Banks",
        "location": "KN 3 Ave, City Center",
        "contact": "+250 788 000 003",
        "description": "Headquarters of I&M Bank Rwanda, offering personal and business banking services.",
        "latitude": -1.9490,
        "longitude": 30.0588,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/i_M_atw9iv.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "Kigali Public Library",
        "category": "Public Services",
        "location": "KG 8 Ave, Kacyiru",
        "contact": "+250 788 000 004",
        "description": "A modern public library offering reading spaces, digital resources, and community programs.",
        "latitude": -1.9378,
        "longitude": 30.0877,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/library_wok6d7.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "Inzora Rooftop Café",
        "category": "Cafés & Dining",
        "location": "KG 5 Ave, Kacyiru",
        "contact": "+250 788 000 005",
        "description": "A popular rooftop café with stunning views of Kigali, known for great coffee and atmosphere.",
        "latitude": -1.9362,
        "longitude": 30.0891,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/inzora-rooftop-cafe_qtviwv.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "CHUK Hospital",
        "category": "Hospitals",
        "location": "KN 4 Ave, Nyarugenge",
        "contact": "+250 788 000 006",
        "description": "Centre Hospitalier Universitaire de Kigali — Rwanda's main university teaching hospital.",
        "latitude": -1.9510,
        "longitude": 30.0576,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/CHUK_rd8afq.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "BK Arena",
        "category": "Public Services",
        "location": "KG 17 Ave, Remera",
        "contact": "+250 788 000 007",
        "description": "Rwanda's largest indoor arena hosting sports events, concerts, and major public gatherings.",
        "latitude": -1.9535,
        "longitude": 30.1127,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/bk_arena_m3vuvg.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "Question Coffee",
        "category": "Cafés & Dining",
        "location": "KG 8 Ave, Gishushu",
        "contact": "+250 788 000 008",
        "description": "A specialty coffee shop supporting Rwandan farmers, known for quality single-origin brews.",
        "latitude": -1.9431,
        "longitude": 30.0775,
        "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "EcoBank Rwanda",
        "category": "Banks",
        "location": "KN 3 Rd, Nyarugenge",
        "contact": "+250 788 000 009",
        "description": "Pan-African bank offering retail and corporate banking solutions across Rwanda.",
        "latitude": -1.9498,
        "longitude": 30.0601,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045651/ecobank_bhh4g2.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
      {
        "title": "Kipharma",
        "category": "Pharmacies",
        "location": "KN 4 Ave, City Center",
        "contact": "+250 788 000 010",
        "description": "One of Kigali's most accessible pharmacies, stocking a wide range of medications and health products.",
        "latitude": -1.9502,
        "longitude": 30.0589,
        "image": "https://res.cloudinary.com/deobfqjgd/image/upload/v1773045652/kipharma_ifxdzc.webp",
        "createdBy": "seed",
        "timestamp": FieldValue.serverTimestamp(),
      },
    ];

    for (var place in kigaliPlaces) {
      await _db.collection('places').add(place);
    }
    print("Kigali Directory Seeded Successfully!");
  }
}