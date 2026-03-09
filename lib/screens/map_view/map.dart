import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/services/directory_service.dart';
import 'package:kigali_directory_app/screens/description_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _kigaliCenter = const LatLng(-1.9441, 30.0619); // Kigali Center

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: Stack(
        children: [
          // 1. The Actual Interactive Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _kigaliCenter,
              initialZoom: 13.0,
            ),
            children: [
              // Dark-themed map tiles (using Stadia Maps or CartoDB Dark Matter)
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),

              // 2. Database-Driven Markers
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const MarkerLayer(markers: []);

                  final markers = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    // Assuming you store 'lat' and 'lng' in Firestore
                    final double lat = data['lat'] ?? -1.9441;
                    final double lng = data['lng'] ?? 30.0619;

                    return Marker(
                      point: LatLng(lat, lng),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _showPlacePreview(context, data),
                        child: _buildCustomMarker(),
                      ),
                    );
                  }).toList();

                  return MarkerLayer(markers: markers);
                },
              ),
            ],
          ),

          // 3. Floating Search Bar (Top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchBar(),
            ),
          ),

          // 4. Bottom Horizontal Preview Slider
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120,
              child: _buildBottomSlider(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMarker() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: KigaliApp.accentGold,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: const Icon(Icons.location_on, color: KigaliApp.primaryNavy, size: 18),
        ),
        Container(
          width: 6,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white38),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search services in Kigali...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          const VerticalDivider(color: Colors.white10, indent: 15, endIndent: 15),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.greenAccent),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSlider() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('places').limit(5).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final docs = snapshot.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _buildMapPreviewCard(context, data);
          },
        );
      },
    );
  }

  Widget _buildMapPreviewCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DescriptionScreen(placeData: data))
      ),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['image'] ?? "https://via.placeholder.com/80",
                width: 80, height: 80, fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? "Place", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(data['location'] ?? "Kiyovu, Kigali", style: const TextStyle(color: Colors.black38, fontSize: 12)),
                  const SizedBox(height: 8),
                  const Text("Open Now • 0.8 km", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlacePreview(BuildContext context, Map<String, dynamic> data) {
    // Center map on the marker when tapped
    _mapController.move(LatLng(data['lat'], data['lng']), 15.0);
  }
}