import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/state/listing_provider.dart';
import 'package:kigali_directory_app/screens/my_listings/add_listings.dart';
import 'package:kigali_directory_app/screens/my_listings/edit_listing.dart';
import 'package:kigali_directory_app/screens/description_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ListingProvider>().listenToMyListings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("My Listings",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text("Manage your contributed places",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const AddListingScreen()),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Listing",
                          style:
                          TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<ListingProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: KigaliApp.accentGold));
                  }

                  if (provider.myListings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.list_alt_outlined,
                              color: Colors.white24, size: 64),
                          const SizedBox(height: 16),
                          const Text("No listings yet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text(
                              "Tap 'Add New Listing' to get started",
                              style:
                              TextStyle(color: Colors.white38)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    itemCount: provider.myListings.length,
                    itemBuilder: (context, index) {
                      final data = provider.myListings[index];
                      return _buildMyListingCard(
                        context,
                        docId: data['docId'] ?? '',
                        title: data['title'] ?? "Unnamed Place",
                        category: data['category'] ?? "Other",
                        loc: data['location'] ?? "Kigali",
                        imageUrl: data['image'] ?? "",
                        data: data,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, String docId, String title) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KigaliApp.cardNavy,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Listing?",
            style: TextStyle(color: Colors.white)),
        content: Text(
            "Are you sure you want to delete '$title'? This cannot be undone.",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<ListingProvider>().deleteListing(docId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("$title deleted"),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  Widget _buildMyListingCard(
      BuildContext context, {
        required String docId,
        required String title,
        required String category,
        required String loc,
        required String imageUrl,
        required Map<String, dynamic> data,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        _buildImagePlaceholder())
                    : _buildImagePlaceholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("$category • $loc",
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildIconButton(Icons.edit_outlined, Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditListingScreen(
                              docId: docId, initialData: data),
                        ),
                      )),
                  const SizedBox(height: 8),
                  _buildIconButton(
                      Icons.delete_outline, Colors.redAccent,
                      onTap: () =>
                          _confirmDelete(context, docId, title)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DescriptionScreen(placeData: data)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("View Details",
                  style:
                  TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12)),
      child: const Icon(Icons.image, color: Colors.white24),
    );
  }

  Widget _buildIconButton(IconData icon, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color.withOpacity(0.8)),
      ),
    );
  }
}