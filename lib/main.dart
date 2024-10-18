import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './src/data_screen.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DexScreener Tokens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      // Named routes for easier navigation
      routes: {
        '/': (context) =>
            const MainScreen(), // Main screen with Drawer Navigation
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the currently selected index

  // List of screens to display
  final List<Widget> _screens = [
    const DataScreen(), // Home or Data screen
    const LoginScreen(), // Login screen
    const RegisterScreen() // Register screen
  ];

  // Drawer menu items
  Widget _buildDrawerMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register'),
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DexScreener Tokens'),
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      drawer: _buildDrawerMenu(context), // Add the drawer
    );
  }
}
