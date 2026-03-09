import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/screens/description_screen.dart';
import 'package:kigali_directory_app/state/listing_provider.dart';
import 'dart:async';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  Timer? _debounce;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All Places";

  final List<String> _categories = [
    "All Places",
    "Public Services",
    "Cafés & Dining",
    "Hospitals",
    "Banks",
    "Pharmacies",
    "Schools",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ListingProvider>().listenToAllListings());
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Discover Kigali",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text("Find services and places",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search services...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon:
                      const Icon(Icons.search, color: Colors.white38),
                      filled: true,
                      fillColor: KigaliApp.cardNavy,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),

            // Category Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) =>
                    _buildCategoryChip(_categories[index]),
              ),
            ),

            const SizedBox(height: 16),

            // Listings via Provider
            Expanded(
              child: Consumer<ListingProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: KigaliApp.accentGold));
                  }
                  if (provider.error != null) {
                    return Center(
                        child: Text("Error: ${provider.error}",
                            style: const TextStyle(
                                color: Colors.redAccent)));
                  }

                  // Client-side search filter
                  final docs = provider.allListings.where((data) {
                    final title =
                    (data['title'] ?? '').toString().toLowerCase();
                    return title.contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                        child: Text("No results found",
                            style: TextStyle(color: Colors.white38)));
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) =>
                        _buildDirectoryCard(context, docs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final bool isActive = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = label);
        context.read<ListingProvider>().listenToAllListings(
          category: label == "All Places" ? null : label,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? KigaliApp.accentGold : KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                color:
                isActive ? KigaliApp.primaryNavy : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    );
  }

  Widget _buildDirectoryCard(
      BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DescriptionScreen(placeData: data)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(20),
          border:
          Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                child: data['image'] != null &&
                    data['image'].isNotEmpty
                    ? Image.network(
                  data['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                      Icons.broken_image,
                      color: Colors.white24),
                )
                    : const Icon(Icons.image,
                    color: Colors.white24, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data['title'] ?? "Unnamed Place",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.white24),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['category'] ?? "General",
                    style: const TextStyle(
                        color: KigaliApp.accentGold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.location_on,
                        color: Colors.white38, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      data['location'] ?? "Kigali",
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 13),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}