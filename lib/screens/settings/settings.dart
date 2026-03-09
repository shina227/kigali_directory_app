import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kigali_directory_app/main.dart';
import 'package:kigali_directory_app/services/auth_service.dart';
import 'package:kigali_directory_app/services/settings_service.dart';
import 'package:kigali_directory_app/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _locationNotifications = true;
  bool _darkMode = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user?.displayName);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(); // Initialize immediately to avoid LateInitializationError

    // Fetch extra fields from Firestore once
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      if (doc.exists && mounted) {
        setState(() {
          _phoneController.text = doc.data()?['phone'] ?? "";
          _locationNotifications = doc.data()?['notificationsEnabled'] ?? true;
          _darkMode = doc.data()?['darkMode'] ?? false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- Logic: Profile Photo Upload ---
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Efficient for student data plans
    );

    if (image == null) return;

    setState(() => _isSaving = true);

    try {
      File file = File(image.path);
      String filePath = 'profile_pics/${user!.uid}.jpg';

      // Upload to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(filePath)
          .putFile(file);

      // Get URL and update Firebase Auth profile
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await user?.updatePhotoURL(downloadUrl);
      await user?.reload(); // Refresh local user state

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated!")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    }
  }

  // --- Logic: Update Text Profile ---
  Future<void> _updateProfile() async {
    setState(() => _isSaving = true);

    try {
      // 1. Update Firebase Auth (for Name)
      await user?.updateDisplayName(_nameController.text.trim());

      // 2. Update Firestore (for everything else)
      await SettingsService().updateUserSettings({
        "fullName": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "notificationsEnabled": _locationNotifications,
        "darkMode": _darkMode,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All settings synced to Cloud!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sync Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header with UI Trigger
            _buildProfileHeader(),
            const SizedBox(height: 32),

            _buildSectionLabel("PERSONAL INFORMATION"),
            _buildInputField("Full Name", _nameController),
            _buildInputField("Email Address", _emailController, enabled: false),
            _buildInputField("Phone Number", _phoneController),

            const SizedBox(height: 24),
            _buildSaveButton(),

            const SizedBox(height: 40),

            _buildSectionLabel("PREFERENCES"),
            _buildPreferenceTile(
              icon: Icons.location_on_outlined,
              title: "Location Notifications",
              value: _locationNotifications,
              onChanged: (val) => setState(() => _locationNotifications = val),
            ),
            _buildPreferenceTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),

            const SizedBox(height: 40),

            _buildSectionLabel("HELP & SUPPORT"),
            _buildSupportTile("Help Center"),
            _buildSupportTile("Report an Issue"),
            _buildSupportTile("About App"),

            const SizedBox(height: 40),

            Center(
              child: TextButton(
                onPressed: () async {
                  await AuthService().logout();
                  // StreamBuilder handles navigation automatically
                },
                child: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: KigaliApp.cardNavy,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(Icons.person, color: Colors.white54, size: 40)
              : null,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.displayName ?? "John Doe",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(user?.email ?? "john@example.rw",
                style: const TextStyle(color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: _isSaving ? null : _pickAndUploadImage,
              child: Text(
                _isSaving ? "Uploading..." : "Change Photo",
                style: const TextStyle(color: KigaliApp.accentGold, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: KigaliApp.cardNavy,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: KigaliApp.accentGold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isSaving
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold, color: KigaliApp.primaryNavy)),
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
  );

  Widget _buildPreferenceTile({required IconData icon, required String title, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(color: KigaliApp.cardNavy, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white38, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Switch(value: value, onChanged: onChanged, activeColor: KigaliApp.accentGold),
      ),
    );
  }

  Widget _buildSupportTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {},
    );
  }
}
