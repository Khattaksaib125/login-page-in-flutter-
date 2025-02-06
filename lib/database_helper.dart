import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("app_database.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5, // Updated version to apply changes
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          await db.execute("DROP TABLE IF EXISTS products");

          await db.execute('''
            CREATE TABLE products (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // Customer Table (No changes here)
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');

    // Product Table (Only ID & Name now)
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
  }

  // ==========================
  // CUSTOMER METHODS (No Changes)
  // ==========================

  Future<void> insertCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    await db.insert("customers", customer, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await instance.database;
    return await db.query("customers");
  }

  Future<void> clearCustomers() async {
    final db = await instance.database;
    await db.delete("customers");
  }

  // ==========================
  // PRODUCT METHODS (Updated)
  // ==========================

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;

    // Ensure the keys match the API response
    await db.insert(
      "products",
      {
        'id': product['id'], // Use 'id' from the processed product map
        'name': product['name'], // Use 'name' from the processed product map
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Inserted Product: ${product['name']}");
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await instance.database;
    return await db.query("products"); // Fetch only ID & Name
  }

  Future<void> clearProducts() async {
    final db = await instance.database;
    await db.delete("products");
  }
}
