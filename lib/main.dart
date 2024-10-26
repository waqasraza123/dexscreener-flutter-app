import 'package:dexscreener_flutter/providers/user_provider.dart';
import 'package:dexscreener_flutter/src/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:provider/provider.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';
import './src/main/main_screen.dart';
import './src/main/theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider()..loadUser(),
      child: const MyApp(),
    ),
  );

  // Initialize Magic Link
  Magic.instance = Magic(dotenv.env['MAGIC_LINK_PUBLISHABLE_KEY']!);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DexScreener Tokens',
      theme: buildAppTheme(),
      home: Stack(children: [const MainScreen(), Magic.instance.relayer]),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
