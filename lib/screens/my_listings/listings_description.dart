import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';

class DescriptionScreen extends StatelessWidget {
  final String title;
  final String category;
  final String location;
  final String description;

  const DescriptionScreen({
    super.key,
    required this.title,
    required this.category,
    required this.location,
    this.description =
        "A beautiful landmark in Kigali offering unique services and a peaceful environment for all visitors.",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: KigaliApp.primaryNavy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://images.unsplash.com/photo-1521587760476-6c12a4b040da",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          // The scrollable content body
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBadge(category),
                  const SizedBox(height: 32),

                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "Address",
                    location,
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Contact",
                    "+250 788 000 000",
                  ),
                  _buildInfoRow(Icons.info_outline, "Description", description),

                  const SizedBox(height: 24),
                  const Text(
                    "Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map Placeholder
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: KigaliApp.cardNavy,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.map_outlined,
                        color: KigaliApp.accentGold,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: KigaliApp.primaryNavy,
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          icon: const Icon(Icons.near_me_outlined),
          label: const Text(
            "Navigate to Location",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: KigaliApp.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: KigaliApp.accentGold,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: KigaliApp.cardNavy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: KigaliApp.accentGold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
