import 'package:flutter/material.dart';

// Helper method to build Bottom Navigation Bar items
List<BottomNavigationBarItem> buildBottomNavBarItems(bool isLoggedIn) {
  return const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
}
