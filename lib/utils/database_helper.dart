import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqf/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
    static final DatabaseHelper _instance = new DatabaseHelper.internal();
    factory DatabaseHelper() => _instance;
    final String tableuser = "userTable";
    final String columnid = "id";
    final String columnusername = "username";
    final String columnpassword = "password";
    static Database _db;
    Future<Database> get db async{
      if (_db!=null)
        {
          return _db;
        }
      _db = await initDb();
      return _db;
    }

  DatabaseHelper.internal();
    initDb() async {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path,"maindb.db");
      var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
      return ourDb;
    }

  void _onCreate(Database db, int version) async {
      await db.execute(
          "CREATE TABLE $tableuser($columnid INTEGER PRIMARY KEY,$columnusername TEXT,$columnpassword TEXT)");
  }
  Future<int> saveuser(User user) async{
      var dbclient = await db;
      int res = await dbclient.insert("$tableuser", user.toMap());
      return res;
  }

  Future<List> getAllUsers() async{
      var dbClient = await db;
      var result = await dbClient.rawQuery("SELECT * FROM $tableuser");
      return result.toList();
  }
  Future<int> getCount() async{
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableuser"));
  }
  Future<User> getUser(int id) async{
      var dbClient = await db;
      var result = await dbClient.rawQuery("SELECT * FROM $tableuser WHERE $columnid = $id");
      if (result.length == 0) return null;
      return new User.fromMap(result.first);
  }
  Future<int> deleteUser(int id) async{
      var dbClient = await db;
      return await dbClient.delete(tableuser,where: "$columnid = ?",whereArgs: [id]);
  }
  Future<int> updateUser(User user) async{
      var dbClient = await db;
      return await dbClient.update(tableuser, user.toMap(),where: "$columnid = ?",whereArgs: [user.id]);
  }
  Future close() async{
      var dbClient = await db;
      return dbClient.close();
  }
}