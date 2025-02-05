import 'package:flutter/material.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String selectedCustomer = "";
  String selectedProduct = "";
  String availableStock = "N/A";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Order"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Search Bar
            TextField(
              controller: customerController,
              decoration: InputDecoration(
                labelText: "Search Customer (by Code or Name)",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onTap: () {
                // Open customer selection screen
              },
            ),
            SizedBox(height: 10),

            // Product Search Bar
            TextField(
              controller: productController,
              decoration: InputDecoration(
                labelText: "Search Product (by ID or Name)",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onTap: () {
                // Open product selection screen
              },
            ),
            SizedBox(height: 10),

            // Available Stock Display
            Text(
              "Available Stock: $availableStock",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Purchasing Amount Input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Purchasing Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Purchasing Quantity Input
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Purchasing Quantity",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Place Order Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Place Order Logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Place Order", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
