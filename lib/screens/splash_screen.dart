import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pg_application/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/screens/main_page_admin.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      navigateToNextScreen();
    });
  }
  void navigateToNextScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else if (user.uid == '8grHNpbvJnUaOoACbtAs9HXJ5zx1') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPageAdmin()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1), 
              Color(0xFF1976D2), 
              Color(0xFF42A5F5), 
              Color(0xFF90CAF9), 
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PGFinder",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Find Your Perfect PG",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
