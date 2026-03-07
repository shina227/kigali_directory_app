import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: Stack(
        children: [
          // 1. The "Map" Background Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: KigaliApp.primaryNavy,
              image: DecorationImage(
                image: const NetworkImage(
                  "https://images.unsplash.com/photo-1526778548025-fa2f459cd5ce",
                ),
                fit: BoxFit.cover,
                opacity: 0.2, // Darkened to let gold markers pop
                colorFilter: ColorFilter.mode(
                  KigaliApp.primaryNavy.withOpacity(0.8),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Custom Gold Markers placed randomly to mimic image_7cf1a6.png
                _buildMapMarker(top: 150, left: 100),
                _buildMapMarker(top: 250, left: 280),
                _buildMapMarker(top: 400, left: 150),
                _buildMapMarker(top: 320, left: 50),
                _buildMapMarker(top: 500, left: 220),

                // Central "Interactive Map View" Label
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: KigaliApp.accentGold.withOpacity(0.5),
                        size: 60,
                      ),
                      const Text(
                        "Interactive Map View",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "10 locations found",
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. The Search Floating Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 55,
                decoration: BoxDecoration(
                  color: KigaliApp.cardNavy,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white38),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search on map...",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: KigaliApp.accentGold,
                    ), // Filter icon from wireframe
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for map pins
  Widget _buildMapMarker({required double top, required double left}) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: KigaliApp.accentGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: KigaliApp.primaryNavy,
              size: 20,
            ),
          ),
          // Small dot shadow
          Container(
            width: 8,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.all(Radius.elliptical(8, 4)),
            ),
          ),
        ],
      ),
    );
  }
}
