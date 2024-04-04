import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:async';
import '../models/goal.dart'; 
import '../models/task.dart'; 
import '../models/habit.dart'; 
import '../models/achievement.dart'; 

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cbt_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Goals table
    await db.execute('''
CREATE TABLE goals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  progress INTEGER NOT NULL,
  isCompleted INTEGER NOT NULL
)
''');

    // Tasks table
    await db.execute('''
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  dueDate TEXT,
  isCompleted INTEGER NOT NULL,
  priority INTEGER NOT NULL
)
''');

    // Habits table
    await db.execute('''
CREATE TABLE habits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  streak INTEGER NOT NULL,
  isCompletedToday INTEGER NOT NULL
)
''');

    // Achievements table
    await db.execute('''
CREATE TABLE achievements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  isUnlocked INTEGER NOT NULL
)
''');
  }

  // CRUD for Goal
  Future<Goal> createGoal(Goal goal) async {
    final db = await instance.database;
    final id = await db.insert('goals', goal.toMap());
    return goal.copy(id: id);
  }

  Future<Goal?> readGoal(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'goals',
      columns: ['id', 'title', 'description', 'progress', 'isCompleted'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Goal.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;
    return db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteGoal(int id) async {
    final db = await instance.database;
    return await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Goal>> getGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('goals');

    return List.generate(maps.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }

  // CRUD for Task
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return task.copy(id: id);
  }

  Future<Task?> readTask(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'tasks',
      columns: ['id', 'title', 'description', 'dueDate', 'isCompleted', 'priority'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> getCompletedTasksCount() async {
    final db = await database;
    // Query the database for tasks where isCompleted is true
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks', // Assuming your table name is 'tasks'
      where: 'isCompleted = ?',
      whereArgs: [1], // Assuming 1 is true for isCompleted
    );
    return maps.length; // Return the count of completed tasks
  }


  // CRUD for Habit
  Future<Habit> createHabit(Habit habit) async {
    final db = await instance.database;
    final id = await db.insert('habits', habit.toMap());
    return habit.copy(id: id);
  }

  Future<Habit?> readHabit(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'habits',
      columns: ['id', 'title', 'streak', 'isCompletedToday'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');

    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  // CRUD for Achievement
  Future<Achievement> createAchievement(Achievement achievement) async {
    final db = await instance.database;
    final id = await db.insert('achievements', achievement.toMap());
    return achievement.copy(id: id);
  }

  Future<Achievement?> readAchievement(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'achievements',
      columns: ['id', 'title', 'description', 'isUnlocked'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Achievement.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await instance.database;
    return db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  Future<int> deleteAchievement(int id) async {
    final db = await instance.database;
    return await db.delete(
      'achievements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Achievement>> getAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');

    return List.generate(maps.length, (i) {
      return Achievement.fromMap(maps[i]);
    });
  }


  // Remember to close the database to avoid memory leaks
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
