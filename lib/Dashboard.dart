import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String loginId;
  final String companyId;
  final String companyName;

  const Dashboard({
    super.key,
    required this.loginId,
    required this.companyId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Padding(
              padding:const EdgeInsets.only (left: 42),
              child: Image.asset(
                'assets/logo.png', // Small logo from login page
                height: 47,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50], // Light background theme
      body: Column(
        children: [
          // Box to show Company ID
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "Company Name: $companyId",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Grid for 4 dashboard boxes
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDashboardCard('New Order', Icons.shopping_cart, Colors.green),
                  _buildDashboardCard('Order List', Icons.list_alt, Colors.orange),
                  _buildDashboardCard('Customer List', Icons.people, Colors.blue),
                  _buildDashboardCard('Product List', Icons.category, Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Add navigation functionality here if needed
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
