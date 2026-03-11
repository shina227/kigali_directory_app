import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/screens/description_screen.dart';
import 'package:kigali_directory_app/services/map_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _kigaliCenter = const LatLng(-1.9441, 30.0619);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: Stack(
        children: [
          // Interactive Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _kigaliCenter,
              initialZoom: 13.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // Dark-themed map tiles
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.kigali.directory',
              ),

              // Database-Driven Markers
              _buildMarkerLayer(),
            ],
          ),

          // Floating Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchBar(),
            ),
          ),

          // Bottom Horizontal Preview Slider
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(height: 120, child: _buildBottomSlider()),
          ),
        ],
      ),
    );
  }

  // Helper to handle Firestore Stream for Markers
  Widget _buildMarkerLayer() {
    return StreamBuilder<QuerySnapshot>(
      stream: MapService().getAllPlaces(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const MarkerLayer(markers: []);

        final markers = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final double lat = (data['latitude'] as num?)?.toDouble() ?? -1.9441;
          final double lng = (data['longitude'] as num?)?.toDouble() ?? 30.0619;

          return Marker(
            point: LatLng(lat, lng),
            width: 45,
            height: 45,
            child: GestureDetector(
              onTap: () => _showPlacePreview(lat, lng),
              child: _buildCustomMarker(),
            ),
          );
        }).toList();

        return MarkerLayer(markers: markers);
      },
    );
  }

  // UI Components

  void _showPlacePreview(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15.0);
  }

  Widget _buildCustomMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: KigaliApp.accentGold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: KigaliApp.primaryNavy,
            size: 20,
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
                hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.white10,
            indent: 15,
            endIndent: 15,
          ),
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
      stream: MapService().getPreviewPlaces(),
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
      onTap: () {
        final double lat = (data['lat'] as num?)?.toDouble() ?? -1.9441;
        final double lng = (data['lng'] as num?)?.toDouble() ?? 30.0619;

        _showPlacePreview(lat, lng);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(placeData: data),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['image'] ?? "https://via.placeholder.com/80",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.white10,
                  width: 80,
                  height: 80,
                  child: const Icon(Icons.image, color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? "Place",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data['location'] ?? "Kiyovu, Kigali",
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Open Now",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
