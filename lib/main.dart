import 'package:flutter/material.dart';
import 'package:kigali_directory_app/screens/auth/login.dart';
import 'package:kigali_directory_app/screens/directory/directory_home.dart';
import 'package:kigali_directory_app/screens/map_view/map.dart';
import 'package:kigali_directory_app/screens/my_listings/my_listings.dart';
import 'package:kigali_directory_app/screens/settings/setings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const KigaliApp());
}

class KigaliApp extends StatelessWidget {
  const KigaliApp({super.key});

  // Colors
  static const Color primaryNavy = Color(0xFF0F172A);
  static const Color accentGold = Color(0xFFEAB308);
  static const Color cardNavy = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: accentGold,
        scaffoldBackgroundColor: primaryNavy,

        // Button styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentGold,
            foregroundColor: primaryNavy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),

        // ColorScheme
        colorScheme: const ColorScheme.dark(
          primary: accentGold,
          secondary: accentGold,
          surface: cardNavy,
          background: primaryNavy,
        ),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const MainNavigation()
          : const LoginScreen(),
    );
  }
}

// Bottom Navigation Bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DirectoryScreen(),
    const MyListingsScreen(),
    const MapScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: KigaliApp.primaryNavy,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Directory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'My Listings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
