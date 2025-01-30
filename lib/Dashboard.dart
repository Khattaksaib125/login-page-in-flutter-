import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String loginId;

  const Dashboard({super.key, required this.loginId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Logged in with Booker ID: $loginId',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
