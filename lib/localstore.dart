import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Store {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" 
    CREATE TABLE items(
    id INTEGER unique,
    stockID INTEGER,
    symbol TEXT,
    companyname TEXT,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  // open databse
  static Future<sql.Database> db() async {
    return sql.openDatabase('stock.db', version: 4,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future createItem(
      int stockID, String symbol, String companyname) async {
    var db = await Store.db();
    var data = {
      'stockID': stockID,
      'symbol': symbol,
      'companyname': companyname,
    };
    var details = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return details;
  }

  // get the data
  static Future<List<dynamic>> getItems() async {
    var db = await Store.db();
    return db.query('items', orderBy: "id");
  }
}
