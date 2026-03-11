import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/state/listing_provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _categories = [
    "Public Services",
    "Cafés & Dining",
    "Hospitals",
    "Banks",
    "Pharmacies",
    "Schools",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<String> _uploadImage(File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('listing_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _handleSubmit() async {
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

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      String imageUrl = "";
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      final newPlace = {
        "title": _nameController.text.trim(),
        "category": _selectedCategory,
        "location": _addressController.text.trim(),
        "contact": _contactController.text.trim(),
        "description": _descriptionController.text.trim(),
        "latitude": -1.9441,
        "longitude": 30.0619,
        "image": imageUrl,
        "status": "active",
      };

      await context.read<ListingProvider>().addListing(newPlace);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("${_nameController.text} added successfully!"),
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
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      appBar: AppBar(title: const Text("Create New Listing")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("Place or Service Name *"),
            _buildTextField(_nameController, "e.g. Kigali Heights Cafe"),

            _buildFieldLabel("Category *"),
            _buildDropdown(),

            _buildFieldLabel("Contact Number"),
            _buildTextField(
              _contactController,
              "+250 788 000 000",
              icon: Icons.phone_outlined,
            ),

            _buildFieldLabel("Address *"),
            _buildTextField(
              _addressController,
              "Enter physical address",
              icon: Icons.location_on,
            ),

            _buildFieldLabel("Description"),
            _buildTextField(
              _descriptionController,
              "Describe the services or highlights...",
              maxLines: 4,
            ),

            _buildFieldLabel("Photo"),
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
                    : const Text(
                        "Submit Listing",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: KigaliApp.cardNavy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedImage != null
                ? KigaliApp.accentGold
                : Colors.white10,
          ),
        ),
        child: _selectedImage != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            "Change",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.orangeAccent.withOpacity(0.5),
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tap to upload a photo",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Text(
                    "PNG, JPG up to 10MB",
                    style: TextStyle(color: Colors.white24, fontSize: 11),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? icon,
    int maxLines = 1,
  }) {
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
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text(
            "Select category",
            style: TextStyle(color: Colors.white24, fontSize: 14),
          ),
          dropdownColor: KigaliApp.cardNavy,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
          isExpanded: true,
          items: _categories
              .map(
                (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat, style: const TextStyle(color: Colors.white)),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
      ),
    );
  }
}
