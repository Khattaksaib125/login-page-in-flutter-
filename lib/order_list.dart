import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Order List"),
      ),
      body: Center(
        child: Text("Order List Screen", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
