import 'package:flutter/material.dart';

// Helper method to build Bottom Navigation Bar items
List<BottomNavigationBarItem> buildBottomNavBarItems(bool isLoggedIn) {
  return [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.trending_up), // Icon for GeckoTokens
      label: 'Tokens',
    ),
    const BottomNavigationBarItem(
      // New BottomNavigationBarItem for Trending NFTs
      icon: Icon(Icons.photo), // You can choose a suitable icon
      label: 'Trending NFTs',
    ),
  ];
}
