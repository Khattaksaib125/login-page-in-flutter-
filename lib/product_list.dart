import 'package:flutter/material.dart';
import 'database_helper.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
    searchController.addListener(() {
      searchProducts(searchController.text);
    });
  }

  Future<void> loadProducts() async {
    try {
      final localProducts = await DatabaseHelper.instance.getAllProducts();
      print("[DEBUG] Loaded products: ${localProducts.length} items");
      setState(() {
        allProducts = localProducts;
        filteredProducts = List.from(localProducts);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading products: $e");
      setState(() => isLoading = false);
    }
  }

  void searchProducts(String query) {
    final cleanQuery = query.trim().toUpperCase();
    print("[DEBUG] Searching for: '$cleanQuery'");

    setState(() {
      filteredProducts = cleanQuery.isEmpty
          ? List.from(allProducts)
          : allProducts.where((product) {
        final id = product["id"]?.toString().toUpperCase() ?? "";
        final name = product["name"]?.toString().toUpperCase() ?? "";
        return name.startsWith(cleanQuery) || id.startsWith(cleanQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Product List"),
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
                  : filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  "No products found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        product["name"] ?? "UNKNOWN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "CODE: ${product["id"] ?? "N/A"}",
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