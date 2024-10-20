import 'package:dexscreener_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './src/data_screen.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';
import './src/user/profile_screen.dart';

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
      home: const MainScreen(), // Main screen with bottom navigation
      routes: {
        '/login': (context) => const LoginScreen(), // Define login route
        '/register': (context) =>
            const RegisterScreen(), // Define register route
      },
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

    // Define the two screens for the bottom navigation: Home and Profile/Login
    final List<Widget> screens = [
      const DataScreen(), // Home screen
      isLoggedIn
          ? const ProfileScreen()
          : const LoginScreen(), // Profile if logged in, Login if not
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
        items: _buildBottomNavBarItems(isLoggedIn),
      ),
    );
  }

  // Helper method to build Bottom Navigation Bar items
  List<BottomNavigationBarItem> _buildBottomNavBarItems(bool isLoggedIn) {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile', // Show Profile or Login based on state
      ),
    ];
  }

  // Get title for AppBar based on selected index and login status
  String _getTitleForIndex(int index, bool isLoggedIn) {
    switch (index) {
      case 0:
        return 'My Dashboard'; // Home screen title
      case 1:
        return isLoggedIn ? 'Profile' : 'Login'; // Profile/Login screen title
      default:
        return '';
    }
  }
}
