import 'package:barrientos_assignment8/models/products.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static const dbname = 'product';
  static const dbVersion = 1;
  static const tbName = 'products';
  static const colid = 'sku';
  static const colName = 'name';
  static const colDescription = 'desc';
  static const colPrice = 'price';
  static const dPrice = 'Dprice';

  static const colQuantity = 'qty';
  static const colManufacturer = 'manu';

  static Future<Database> OpenDB() async {
    var path = join(await getDatabasesPath(), Dbhelper.dbname);

    var db = await openDatabase(
      path,
      version: Dbhelper.dbVersion,
      onCreate: (db, version) {
        var sql = '''
  CREATE TABLE IF NOT EXISTS $tbName (
    $colid INTEGER PRIMARY KEY AUTOINCREMENT,
    $colName TEXT,
    $colDescription TEXT,
    $colPrice DECIMAL,
    $dPrice DECIMAL,
    $colQuantity DECIMAL,
    $colManufacturer TEXT
  )
''';
        db.execute(sql);
        print(sql);
        print('table $tbName is created');
      },
    );

    return db;
  }

  static void insertProduct(Product product) async {
    final db = await OpenDB();
    var id = await db.insert(
      tbName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('data inserted');
  }

  static Future<List<Map<String, dynamic>>> fetchRaw() async {
    final db = await OpenDB();
    return await db.rawQuery('SELECT * FROM $tbName');
  }

  static Future<void> deleteProduct(Product product) async {
    final db = await OpenDB();
    await db.delete(
      tbName,
      where: "$colName = ?",
      whereArgs: [product.name],
    );
    print('Product deleted: ${product.name}');
  }

  static Future<void> updateProduct(
      Product oldProduct, Product newProduct) async {
    final db = await OpenDB();
    await db.update(
      tbName,
      newProduct.toMap(),
      where: "$colName = ?",
      whereArgs: [oldProduct.name],
    );
    print('Product updated: ${newProduct.name}');
  }
}
