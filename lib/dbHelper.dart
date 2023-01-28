// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static const dbVersion = 1;
  static const String dbName = 'main.db';
  static const dbTable = 'tasks';
  static const column2 = 'title';
  static const column3 = 'description';
  static const column1 = 'id';
  String? path;
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await initDb();

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    path = join(directory.path, dbName);
    return await openDatabase(path!, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    db.execute(
        'CREATE TABLE $dbTable($column1 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,$column2 TEXT NOT NULL, $column3 TEXT)');
  }

  Future newTask(Map<String, String> task) async {
    final db = await database;
    db.insert(dbTable, task);
  }

  Future getAllTask() async {
    final db = await database;
    return await db.query(dbTable);
  }

  Future taskDone(int? id) async {
    final db = await database;
    db.delete(dbTable, where: "id =?", whereArgs: [id]);
  }
}
