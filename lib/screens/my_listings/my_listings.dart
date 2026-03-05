import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/screens/my_listings/add_listings.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Listings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Manage your contributed places",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // "Add New Listing" Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddListingScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add New Listing",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Listings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildMyListingCard(
                    context,
                    "My Favorite Café",
                    "Café",
                    "KG 15 Ave, Kigali",
                  ),
                  _buildMyListingCard(
                    context,
                    "Local Bookstore",
                    "Shopping Mall",
                    "KN 10 St, Kigali",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListingCard(
    BuildContext context,
    String title,
    String category,
    String loc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(16),
      ),
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
          const SizedBox(height: 4),
          Text(
            category,
            style: const TextStyle(color: KigaliApp.accentGold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Text(
                loc,
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {}, // Navigate to DescriptionScreen
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white10),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildIconButton(Icons.edit_outlined, Colors.blue),
              const SizedBox(width: 8),
              _buildIconButton(Icons.delete_outline, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: color.withOpacity(0.8)),
    );
  }
}
