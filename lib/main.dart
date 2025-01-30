import 'package:flutter/material.dart';
import 'package:flutterproject/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Corrected from login_page() to LoginPage()
    );
  }
}
