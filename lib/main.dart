import 'package:dexscreener_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:provider/provider.dart';
import './src/auth/login_screen.dart';
import './src/auth/register_screen.dart';
import './src/main/main_screen.dart';
import './src/main/theme.dart';
import 'src/auth/magic_link/email_otp_login_screen.dart';
import 'src/auth/magic_link/magic_link_otp_verification_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");

  // Initialize Magic Link
  Magic.instance = Magic(dotenv.env['MAGIC_LINK_PUBLISHABLE_KEY']!);

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
      home: Stack(children: [const MainScreen(), Magic.instance.relayer]),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/email-otp-login': (context) => const MagicLinkEmailOTPLoginScreen(),
        '/email-otp-login-confirmation': (context) =>
            const MagicLinkOtpVerificationScreen()
      },
    );
  }
}
