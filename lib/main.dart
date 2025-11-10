// lib/main.dart
import 'package:adv_formacion/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/screens/auth/login_screen.dart';
import 'package:adv_formacion/screens/dashboard_screen.dart';
import 'package:adv_formacion/screens/profile/profile_screen.dart';
import 'package:adv_formacion/screens/tests/test_screen.dart';
import 'package:adv_formacion/screens/tests/aesa_exam_screen.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AdvFormacionApp());
}

class AdvFormacionApp extends StatelessWidget {
  const AdvFormacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return MaterialApp(
          title: 'ADV Formación',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: user == null ? const LoginScreen() : const DashboardScreen(),
          routes: {
            '/dashboard': (context) => const DashboardScreen(),
            '/aesa_exam': (context) => const AesaExamScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/test_screen') {
              final args = settings.arguments as Map<String, dynamic>;
              final category = args['category'] as TestCategory;
              final userId = args['userId'] as String;
              return MaterialPageRoute(
                builder: (context) => TestScreen(
                  category: category,
                  userId: userId,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
