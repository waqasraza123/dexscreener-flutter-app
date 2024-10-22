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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");

  // Set the platform-specific WebView implementation for Android and iOS
  if (WebViewPlatform.instance == null) {
    if (kIsWeb) {
      WebViewPlatform.instance =
          WebWebViewPlatform(); // Set Web platform implementation
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      WebViewPlatform.instance = AndroidWebViewPlatform();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      WebViewPlatform.instance = WebKitWebViewPlatform();
    }
  }

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
      home: const Stack(children: [MainScreen()]),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/email-otp-login': (context) => const MagicLinkEmailOTPLoginScreen()
      },
    );
  }
}
