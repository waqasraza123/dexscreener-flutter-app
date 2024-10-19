import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dexscreener_flutter/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: Colors.grey[500],
              ),
            ),

            const SizedBox(height: 20),

            // User email or name
            Text(
              user?.email ?? 'Guest User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 5),

            // User ID or any other info (optional)
            if (user?.uid != null)
              Text(
                'UID: ${user!.uid}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

            const SizedBox(height: 40),

            // Account Settings / Profile Information section (if needed)
            _buildProfileOption(
              icon: Icons.settings_outlined,
              label: 'Account Settings',
              onTap: () {
                // Handle Account Settings tap
              },
            ),
            const SizedBox(height: 10),

            _buildProfileOption(
              icon: Icons.lock_outline,
              label: 'Privacy Settings',
              onTap: () {
                // Handle Privacy Settings tap
              },
            ),

            const Spacer(),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  userProvider.logoutUser();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build profile options
  Widget _buildProfileOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
