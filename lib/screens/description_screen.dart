import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kigali_directory_app/main.dart';

class DescriptionScreen extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const DescriptionScreen({super.key, required this.placeData});

  Future<void> _makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri url = Uri.parse('tel:${phoneNumber.replaceAll(' ', '')}');
    try {
      if (await canLaunchUrl(url)) await launchUrl(url);
    } catch (e) {
      debugPrint("Could not launch $url");
    }
  }

  Future<void> _launchDirections(double lat, double lng, String name) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=${Uri.encodeComponent(name)}&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double lat = (placeData['latitude'] ?? -1.9441).toDouble();
    final double lng = (placeData['longitude'] ?? 30.0619).toDouble();
    final String name = placeData['title'] ?? 'Location';

    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            stretch: true,
            backgroundColor: KigaliApp.primaryNavy,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Image.network(
                placeData['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: KigaliApp.cardNavy,
                  child: const Icon(Icons.broken_image, color: Colors.white24),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: KigaliApp.primaryNavy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(placeData['category'] ?? 'General'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: KigaliApp.accentGold, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          placeData['location'] ?? 'Kigali, Rwanda',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeCall(placeData['contact']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.phone, size: 20),
                          label: const Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildSquareAction(Icons.favorite_border, () {}),
                      const SizedBox(width: 12),
                      _buildSquareAction(Icons.share_outlined, () {}),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // About
                  const Text("About",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(
                    placeData['description'] ?? 'No description provided for this location.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 36),

                  // Location Map
                  const Text("Location",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),

                  // Embedded OpenStreetMap
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 220,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(lat, lng),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.kigali.directory',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(lat, lng),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Get Directions Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchDirections(lat, lng, name),
                      icon: const Icon(Icons.directions),
                      label: const Text("Get Directions",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            color: Colors.greenAccent, fontSize: 11,
            fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildSquareAction(IconData icon, VoidCallback onTap) {
    return Container(
      height: 54, width: 54,
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
        onPressed: onTap,
      ),
    );
  }
}