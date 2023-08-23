import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/CartModel.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();

  factory CartDatabaseHelper() => _instance;

  CartDatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<CartItem?> getCartItemByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return CartItem.fromJson(maps.first);
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        ponus1 INTEGER NOT NULL
      )
    ''');
  }

  // Method to clear the cart database
  Future<void> clearCart() async {
    final db = await database;
    await db!.delete('cart'); // Delete all records from the 'cart' table
  }

  Future<int> insertCartItem(CartItem item) async {
    final db = await database;
    return await db!.insert('cart', item.toJson());
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('cart');
    return List.generate(
      maps.length,
      (i) => CartItem.fromJson(maps[i]),
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db!.update(
      'cart',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
