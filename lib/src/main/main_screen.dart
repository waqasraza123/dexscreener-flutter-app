import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dexscreener_flutter/providers/user_provider.dart';
import '../data_screen.dart';
import '../user/profile_screen.dart';
import '../auth/login_screen.dart';
import 'bottom_navigation.dart';
import '../token/gecko/gecko_tokens_screen.dart';
import '../nfts/trending_nfts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Function to handle navigation on bottom bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final bool isLoggedIn = userProvider.user?.accessToken != null;

    // Define the four screens for the bottom navigation: Home, Profile/Login, GeckoTokens, and Trending NFTs
    final List<Widget> screens = [
      const DataScreen(), // Home screen
      isLoggedIn
          ? const ProfileScreen()
          : const LoginScreen(), // Profile or Login
      const GeckoTokensScreen(), // GeckoTokensScreen
      TrendingNFTsScreen(), // Add TrendingNFTsScreen here
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getTitleForIndex(_selectedIndex, isLoggedIn),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 5,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: buildBottomNavBarItems(isLoggedIn), // Updated method call
      ),
    );
  }

  // Get title for AppBar based on selected index and login status
  String _getTitleForIndex(int index, bool isLoggedIn) {
    switch (index) {
      case 0:
        return 'My Dashboard';
      case 1:
        return isLoggedIn ? 'Profile' : 'Login';
      case 2:
        return 'Trending Cryptocurrencies';
      case 3: // New case for Trending NFTs
        return 'Trending NFTs';
      default:
        return '';
    }
  }
}
