import 'package:flutter/material.dart';
import 'package:kigali_directory_app/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KigaliApp.primaryNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Manage your account and preferences",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: KigaliApp.cardNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: KigaliApp.primaryNavy,
                          child: Text(
                            "JD",
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: KigaliApp.accentGold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: KigaliApp.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "john.doe@example.com",
                      style: TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: KigaliApp.accentGold),
                        foregroundColor: KigaliApp.accentGold,
                      ),
                      child: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Preferences Section
              const Text(
                "Preferences",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingTile(
                icon: Icons.notifications_none,
                title: "Location Notifications",
                subtitle: "Get alerts for nearby places",
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: KigaliApp.accentGold,
                ),
              ),

              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingTile(
                icon: Icons.location_on_outlined,
                title: "My Locations",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.person_outline,
                title: "Account Settings",
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.logout,
                title: "Logout",
                titleColor: Colors.redAccent,
                onTap: () => {},
                // Navigator.of(context).popToRoot(), // Return to Login
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color titleColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: KigaliApp.cardNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: KigaliApp.primaryNavy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: titleColor == Colors.redAccent
                ? Colors.redAccent
                : KigaliApp.accentGold,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              )
            : null,
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}
