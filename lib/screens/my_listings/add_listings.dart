import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for User ID
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/services/listing_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    "Public Services",
    "Cafés & Dining",
    "Hospitals",
    "Banks",
    "Pharmacies",
    "Schools"
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 2. Submit Logic
  Future<void> _handleSubmit() async {
    // Basic Validation
    if (_nameController.text.isEmpty ||
        _selectedCategory == null ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields (*)"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Modern UX: Hide keyboard on submit
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    // Get current user for ownership
    final user = FirebaseAuth.instance.currentUser;

    // Data Preparation
    final newPlace = {
      "userId": user?.uid, // Essential for "My Listings" filtering
      "title": _nameController.text.trim(),
      "category": _selectedCategory,
      "location": _addressController.text.trim(),
      "description": _descriptionController.text.trim(),
      "phone": _phoneController.text.trim(),
      "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    };

    try {
      await ListingService().addListing(newPlace);

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("${_nameController.text} submitted for review!"),
                ),
              ],
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      appBar: AppBar(
        title: const Text("Create New Listing"),
        // AppBar style is now handled globally in main.dart
      ),
      body: SingleChildScrollView(
        // Helps avoid issues with the keyboard on smaller devices
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("Business or Place Name *"),
            _buildTextField(_nameController, "e.g. Kigali Heights Cafe"),

            _buildFieldLabel("Category *"),
            _buildDropdown(),

            _buildFieldLabel("Contact Phone Number"),
            _buildTextField(_phoneController, "+250 788 000 000",
                icon: Icons.phone_outlined),

            _buildFieldLabel("Address / Location *"),
            _buildTextField(_addressController, "Enter physical address",
                icon: Icons.location_on),

            _buildFieldLabel("Description"),
            _buildTextField(_descriptionController,
                "Describe the services or highlights...",
                maxLines: 4),

            _buildFieldLabel("Upload Photos"),
            _buildUploadBox(),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: KigaliApp.primaryNavy,
                    strokeWidth: 2,
                  ),
                )
                    : const Text("Submit Listing",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                "By submitting, you agree to the Terms of Use.",
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {IconData? icon, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: KigaliApp.cardNavy,
        suffixIcon: icon != null
            ? Icon(icon, color: Colors.orangeAccent, size: 20)
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: KigaliApp.cardNavy, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text("Select category",
              style: TextStyle(color: Colors.white24, fontSize: 14)),
          dropdownColor: KigaliApp.cardNavy,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
          isExpanded: true,
          items: _categories
              .map((cat) => DropdownMenuItem(
              value: cat,
              child: Text(cat, style: const TextStyle(color: Colors.white))))
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return InkWell(
      onTap: () {
        // Future: Integration with image_picker
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.add_a_photo_outlined,
                color: Colors.orangeAccent.withOpacity(0.5), size: 40),
            const SizedBox(height: 12),
            const Text("Click to upload photos",
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const Text("PNG, JPG up to 10MB",
                style: TextStyle(color: Colors.white24, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}