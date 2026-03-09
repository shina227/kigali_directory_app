import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionScreen extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const DescriptionScreen({super.key, required this.placeData});

  // Helper to launch phone calls safely
  Future<void> _makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    final Uri url = Uri.parse('tel:${phoneNumber.replaceAll(' ', '')}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Sleek App Bar with Dynamic Image
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
                placeData['image'] ?? "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: KigaliApp.cardNavy,
                  child: const Icon(Icons.broken_image, color: Colors.white24),
                ),
              ),
            ),
          ),

          // 2. Content Section
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
                  // Title and Category Chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          placeData['title'] ?? "Unnamed Place",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(placeData['category'] ?? "General"),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location Row
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: KigaliApp.accentGold, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          placeData['location'] ?? "Kigali, Rwanda",
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Action Buttons (Contact, Like, Share)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeCall(placeData['phone']),
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
                      _buildSquareAction(Icons.favorite_border),
                      const SizedBox(width: 12),
                      _buildSquareAction(Icons.share_outlined),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // About Section
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    placeData['description'] ?? "No description provided for this location.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Location Map Preview
                  const Text(
                    "Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _buildMapPlaceholder(),

                  const SizedBox(height: 60), // Bottom padding for scroll
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
          color: Colors.greenAccent,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSquareAction(IconData icon) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
        onPressed: () {},
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        width: double.infinity,
        color: KigaliApp.cardNavy,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.1,
              child: Icon(Icons.map_rounded, color: Colors.white, size: 100),
            ),
            Positioned(
              bottom: 20,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text("Get Directions", style: TextStyle(color: Colors.white)),
              ),
            ),
            const Icon(Icons.location_pin, color: Colors.redAccent, size: 36),
          ],
        ),
      ),
    );
  }
}