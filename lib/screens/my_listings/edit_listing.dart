import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/services/listing_service.dart';

class EditListingScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;

  const EditListingScreen({
    super.key,
    required this.docId,
    required this.initialData
  });

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;

  bool _isLoading = false;

  final List<String> _categories = [
    "Public Services",
    "Cafés & Dining",
    "Hospitals",
    "Banks",
    "Pharmacies",
    "Schools"
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate controllers with existing Firestore data
    _nameController = TextEditingController(text: widget.initialData['title'] ?? "");
    _phoneController = TextEditingController(text: widget.initialData['phone'] ?? "");
    _addressController = TextEditingController(text: widget.initialData['location'] ?? "");
    _descriptionController = TextEditingController(text: widget.initialData['description'] ?? "");
    _selectedCategory = widget.initialData['category'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    // Validation
    if (_nameController.text.isEmpty || _selectedCategory == null || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Required fields cannot be empty"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() => _isLoading = true);

    final updatedData = {
      "title": _nameController.text.trim(),
      "category": _selectedCategory,
      "location": _addressController.text.trim(),
      "description": _descriptionController.text.trim(),
      "phone": _phoneController.text.trim(),
      "updatedAt": FieldValue.serverTimestamp(), // Better for DB consistency
    };

    try {
      await ListingService().updateListing(widget.docId, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Changes saved successfully!"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      appBar: AppBar(
        title: const Text("Edit Listing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("Business or Place Name *"),
            _buildTextField(_nameController, "Place Name"),

            _buildFieldLabel("Category *"),
            _buildDropdown(),

            _buildFieldLabel("Contact Phone Number"),
            _buildTextField(_phoneController, "Phone Number", icon: Icons.phone_outlined),

            _buildFieldLabel("Address / Location *"),
            _buildTextField(_addressController, "Address", icon: Icons.location_on),

            _buildFieldLabel("Description"),
            _buildTextField(_descriptionController, "Description", maxLines: 4),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                child: _isLoading
                    ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: KigaliApp.primaryNavy, strokeWidth: 2)
                )
                    : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Reusable UI Helpers ---

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {IconData? icon, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: KigaliApp.cardNavy,
        suffixIcon: icon != null ? Icon(icon, color: Colors.orangeAccent, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: KigaliApp.cardNavy, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          dropdownColor: KigaliApp.cardNavy,
          isExpanded: true,
          items: _categories
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white))))
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
      ),
    );
  }
}