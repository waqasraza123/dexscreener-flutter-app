import 'package:dexscreener_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './src/data_screen.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';
import './src/user/profile_screen.dart'; // Import the Profile screen

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider()..loadUser(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DexScreener Tokens',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

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

    // Adjust the list of screens dynamically based on the login status
    final List<Widget> _screens = [
      const DataScreen(), // Home screen
      if (isLoggedIn)
        const ProfileScreen()
      else
        const LoginScreen(), // Show profile if logged in, otherwise login
      if (!isLoggedIn)
        const RegisterScreen(), // Register screen only for non-logged users
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 5,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _buildBottomNavBarItems(isLoggedIn),
      ),
    );
  }

  // Helper method to build Bottom Navigation Bar items
  List<BottomNavigationBarItem> _buildBottomNavBarItems(bool isLoggedIn) {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Add Login/Register items only if the user is not logged in
    if (!isLoggedIn) {
      items.addAll([
        const BottomNavigationBarItem(
          icon: Icon(Icons.login_outlined),
          label: 'Login',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_add_outlined),
          label: 'Register',
        ),
      ]);
    }

    return items;
  }

  // Get title for AppBar based on selected index and login status
  String _getTitleForIndex(int index, bool isLoggedIn) {
    switch (index) {
      case 0:
        return 'My Dashboard'; // Home screen title
      case 1:
        return isLoggedIn ? 'Profile' : 'Login'; // Profile/Login screen title
      case 2:
        return 'Register'; // Register screen title (only for non-logged users)
      default:
        return '';
    }
  }
}
