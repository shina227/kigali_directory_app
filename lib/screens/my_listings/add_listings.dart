import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add New Listing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("Place Name *"),
            _buildTextField("e.g., Heaven Restaurant"),
            _buildFieldLabel("Category *"),
            _buildTextField("Select a category", isDropdown: true),
            _buildFieldLabel("Address *"),
            _buildTextField(
              "e.g., KG 7 Ave, Kigali",
              icon: Icons.location_on_outlined,
            ),
            _buildFieldLabel("Description *"),
            _buildTextField("Tell us about this place...", maxLines: 4),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Add Listing",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    bool isDropdown = false,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: KigaliApp.cardNavy,
        prefixIcon: icon != null ? Icon(icon, color: Colors.white38) : null,
        suffixIcon: isDropdown
            ? const Icon(Icons.keyboard_arrow_down, color: Colors.white38)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
