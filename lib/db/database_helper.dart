import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/task_model.dart';

class DatabaseHelper {
  static final _dbName = 'tasks.db';
  static final _dbVersion = 1;
  static final _tableName = 'todo_table';

  static Database? _database; // Singleton Database

  String columnId = 'id';
  String columnTaskId = 'task_id';
  String columnName = 'name';
  String columnCompletionStatus = 'status';
  String columnDate = 'date';

  // Named constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();
  static final DatabaseHelper instance = DatabaseHelper._createInstance();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _dbName;

    return await openDatabase(path, version: _dbVersion, onCreate: _createDb);
  }

  Future _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $_tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnTaskId TEXT NOT NULL, $columnName TEXT NOT NULL,'
        '$columnCompletionStatus TEXT, $columnDate INTEGER)');
  }

  // Fetch Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await instance.database;

    var result = await db.query(_tableName,
        orderBy: '$columnCompletionStatus ASC'); //orderBy: '$columnName ASC'
    return result;
  }

  // Insert Operation: Insert a task object to database
  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(_tableName, task.toMap());
  }

  // Update Operation: Update a task object and save it to database
  Future<int> updateTask(Task task) async {
    var db = await instance.database;
    return await db.update(_tableName, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.taskId]);
  }

  Future<int> updateTaskCompleted(Task task) async {
    var db = await instance.database;
    return await db.update(_tableName, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.taskId]);
  }

  // Delete Operation: Delete a task object from database
  Future<int> deleteTask(int id) async {
    var db = await instance.database;
    return await db.rawDelete('DELETE FROM $_tableName WHERE $columnId = $id');
  }

  Future<int> deleteTable() async {
    var db = await instance.database;
    return await db.delete(_tableName);
  }

  // Get number of task objects in database
  Future<int> getCount() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $_tableName');
    int? result = Sqflite.firstIntValue(x);
    return result != null ? result : 0;
  }

  Future<List<Task>> getTaskList() async {
    var todoMapList = await getTaskMapList(); // Get 'Map List' from database
    int count =
        todoMapList.length; // Count the number of map entries in db table

    List<Task> todoList = [];
    // For loop to create a 'task List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Task.fromMapObject(todoMapList[i]));
    }
    return todoList;
  }
}
