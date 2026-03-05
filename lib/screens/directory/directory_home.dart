import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/screens/directory/directory_description.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discover Kigali",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Find services and places",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: KigaliApp.cardNavy,
                        child: const Icon(
                          Icons.person,
                          color: KigaliApp.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search services, clinics, cafes...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white38,
                      ),
                      filled: true,
                      fillColor: KigaliApp.cardNavy,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildCategoryChip("All Places", isActive: true),
                  _buildCategoryChip("Public Services"),
                  _buildCategoryChip("Cafés & Dining"),
                  _buildCategoryChip("Hospitals"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Directory List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildDirectoryCard(
                    context,
                    title: "Kigali Public Library",
                    category: "Public Service",
                    location: "KG 8 Ave, Kacyiru",
                    image:
                        "https://images.unsplash.com/photo-1521587760476-6c12a4b040da",
                  ),
                  _buildDirectoryCard(
                    context,
                    title: "Question Coffee",
                    category: "Café & Dining",
                    location: "KG 8 Ave, Gishushu",
                    image:
                        "https://images.unsplash.com/photo-1554118811-1e0d58224f24",
                  ),
                  _buildDirectoryCard(
                    context,
                    title: "Nyandungu Urban Wetland",
                    category: "Park",
                    location: "Kigali-Muhanga Rd, Kigali",
                    image:
                        "https://images.unsplash.com/photo-1554118811-1e0d58224f24",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Category Chip
  Widget _buildCategoryChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? KigaliApp.accentGold : KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? KigaliApp.primaryNavy : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Reusable Directory Card
  Widget _buildDirectoryCard(
    BuildContext context, {
    required String title,
    required String category,
    required String location,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(
              title: title,
              category: category,
              location: location,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                color: Colors.grey.shade800,
              ),
              child: const Center(
                child: Icon(Icons.image, color: Colors.white24, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: KigaliApp.accentGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: KigaliApp.accentGold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white38,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
