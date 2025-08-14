import 'package:flutter/material.dart';
// import 'package:pg_application/screens/addnewpg_screen.dart';
// import 'package:pg_application/screens/admin_screen.dart';
// import 'package:pg_application/screens/home_screen.dart';
// import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/screens/login_screen.dart';
// import 'package:pg_application/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. hehe by Neeeeell
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PG Application',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const Login(),
    );
  }
}
