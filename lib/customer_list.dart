import 'package:flutter/material.dart';
import 'database_helper.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
    searchController.addListener(() {
      searchCustomers(searchController.text);
    });
  }

  Future<void> loadCustomers() async {
    try {
      final localCustomers = await DatabaseHelper.instance.getAllCustomers();
      print("[DEBUG] Loaded customers: ${localCustomers.length} items"); // Debug
      setState(() {
        allCustomers = localCustomers;
        filteredCustomers = List.from(localCustomers); // Initial list
        isLoading = false;
      });
    } catch (e) {
      print("Error loading customers: $e");
      setState(() => isLoading = false);
    }
  }

  void searchCustomers(String query) {
    final cleanQuery = query.trim().toUpperCase();
    print("[DEBUG] Searching for: '$cleanQuery'"); // Debug

    if (cleanQuery.isEmpty) {
      setState(() => filteredCustomers = List.from(allCustomers));
      return;
    }

    setState(() {
      filteredCustomers = allCustomers.where((customer) {
        final id = customer["id"]?.toString().toUpperCase() ?? "";
        final name = customer["name"]?.toString().toUpperCase() ?? "";

        // Check if name or ID STARTS WITH the query
        return name.startsWith(cleanQuery) || id.startsWith(cleanQuery);
      }).toList();
    });

    print("[DEBUG] Found ${filteredCustomers.length} results"); // Debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Customer List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Code or Name",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredCustomers.isEmpty
                  ? Center(
                child: Text(
                  "No customers found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        customer["name"] ?? "UNKNOWN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "CODE: ${customer["id"] ?? "N/A"}\n"
                            "ADDRESS: ${customer["address"] ?? "NO ADDRESS"}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}