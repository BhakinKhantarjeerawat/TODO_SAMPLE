/// There are 3 screens in this app: 1.HomeScreen(for showing tasks) 2.AddTaskScreen 3.UpdateTaskScreen
/// Values are transfered between screens(classes) with Providers (DatabaseHelper Provider and TaskDetailProvider)
/// widgets, if can be stand alone outside of class(screens), they are in GlobalWidgets

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_hugeman/database/task.dart';

class DatabaseHelper with ChangeNotifier {

  /// use _privateConstructor to create a class that only has one instance.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  /// return _database, if it is null set it with method _initDatabase
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    /// use flutter package named 'path' to join the path with 'tasks.db'
    String path = join(documentsDirectory.path, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
          id TEXT ,
          name TEXT,
          status TEXT,
          desc TEXT,
          date TEXT
      )
      ''');
  }

  Future<List<Task>> getTasks({sortBy, filterBy, searchText}) async {
    Database db = await instance.database;
    var tasks = await db.query('tasks', orderBy: sortBy);
    List<Task> taskList =
        tasks.isNotEmpty ? tasks.map((c) => Task.fromMap(c)).toList() : [];
    /// Notify ChangeNotifier with notifyListeners(); below
    notifyListeners();
    return filterBy == 'name'
        ? taskList
            .where((element) => element.name.contains(searchText))
            .toList()
        : taskList
            .where((element) => element.desc.contains(searchText))
            .toList();
  }

  Future<int> add(Task task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> remove(String id) async {
    Database db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    Database db = await instance.database;
    return await db
        .update('tasks', task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }
}
