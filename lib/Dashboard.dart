import 'package:flutter/material.dart';
import 'new_order.dart';
import 'order_list.dart';
import 'customer_list.dart';
import 'product_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_helper.dart';

class Dashboard extends StatefulWidget {
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
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isRefreshing = false;
  bool dataFetched = false; // ✅ Ensures data is fetched only once

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 8.0),
              child: Image.asset('assets/logo.png', height: 47),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        children: [
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
                      "Company ID: ${widget.companyId}",
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDashboardCard(context, 'New Order', Icons.shopping_cart, Colors.green, NewOrderScreen()),
                  _buildDashboardCard(context, 'Order List', Icons.list_alt, Colors.orange, OrderListScreen()),
                  _buildDashboardCard(context, 'Customer List', Icons.people, Colors.blue, CustomerListScreen()),
                  _buildDashboardCard(context, 'Product List', Icons.category, Colors.purple, ProductListScreen()),

                  // Refresh Data Card
                  GestureDetector(
                    onTap: () async {
                      if (!dataFetched) { // ✅ Prevents multiple refreshes
                        setState(() => isRefreshing = true);
                        await refreshCustomerData();
                        setState(() {
                          isRefreshing = false;
                          dataFetched = true;
                        });
                      }
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
                            isRefreshing
                                ? CircularProgressIndicator()
                                : Icon(Icons.refresh, size: 50, color: dataFetched ? Colors.grey : Colors.red),
                            SizedBox(height: 10),
                            Text(
                              dataFetched ? " Updated" : "Refresh Data",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
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

  Future<void> refreshCustomerData() async {
    try {
      final response = await http.get(Uri.parse("http://isofttouch.com/APP471/customer.php"));
      if (response.statusCode == 200) {
        List<dynamic> rawData = jsonDecode(response.body);
        print("[DEBUG] Raw API data: $rawData"); // Debug

        List<Map<String, dynamic>> customers = rawData.map((item) {
          return {
            "id": item["cid"]?.toString().trim().toUpperCase() ?? "N/A",
            "name": item["cname"]?.toString().trim().toUpperCase() ?? "UNKNOWN",
            "address": item["address1"]?.toString().trim().toUpperCase() ?? "NO ADDRESS",
          };
        }).toList();

        print("[DEBUG] Processed customers: ${customers.length} items"); // Debug

        await DatabaseHelper.instance.clearCustomers();
        for (var customer in customers) {
          await DatabaseHelper.instance.insertCustomer(customer);
        }

        print("Customer data refreshed successfully");
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Refresh failed: $e");
    }
  }
}
