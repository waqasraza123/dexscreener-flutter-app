import 'package:dexscreener_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';
import './src/main/main_screen.dart';
import './src/main/theme.dart';
//import '../utils/magic_link_init.dart';
import 'src/auth/magic_link/email_otp_login_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");

  // Initialize Magic Link
  //MagicLinkInit.init();

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
      theme: buildAppTheme(),
      home: const MainScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/email-otp-login': (context) => const MagicLinkEmailOTPLoginScreen()
      },
    );
  }
}
