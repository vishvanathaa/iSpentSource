import 'dart:async';
import 'dart:io' as io;
import 'package:ispent/database/model/expenditure.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "vishwakarma.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Expenditure(id INTEGER PRIMARY KEY, amount REAL, itemname TEXT, entrydate TEXT,icon TEXT,note TEXT)");
  }

  Future<int> saveUser(Expenditure expenditure) async {
    var dbClient = await db;
    int res = await dbClient.insert("Expenditure", expenditure.toMap());
    return res;
  }

  Future<List<Expenditure>> getExpenses(int month, int year, int mode) async {
    var dbClient = await db;
    var query;
    if(mode == 0) {
      query =
          "SELECT * FROM Expenditure WHERE CAST(strftime('%m', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
              month.toString() + " AND  CAST(strftime('%Y', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
      year.toString() + "";
    }else {
      query =
          "SELECT * FROM Expenditure WHERE CAST(strftime('%Y', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
              year.toString() + "";
    }
     List<Map> list = await dbClient.rawQuery(query);
    List<Expenditure> expenses = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new Expenditure(list[i]["amount"], list[i]["itemname"],
          list[i]["entrydate"], list[i]["icon"], list[i]["note"]);
      user.setExpenditureId(list[i]["id"]);
      expenses.add(user);
    }
    //print(expenses.length);
    return expenses;
  }

  Future<int> deleteUsers(Expenditure expense) async {
    var dbClient = await db;
    print(expense.id);
    int res = await dbClient
        .rawDelete('DELETE FROM Expenditure WHERE id = ?', [expense.id]);
    return res;
  }

  Future<bool> update(Expenditure expense) async {
    var dbClient = await db;
    int res = await dbClient.update("Expenditure", expense.toMap(),
        where: "id = ?", whereArgs: <int>[expense.id]);
    return res > 0 ? true : false;
  }
}
