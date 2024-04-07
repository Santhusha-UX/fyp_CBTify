import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:async';
import '../models/goal.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/achievement.dart';
import '../models/thought_challenge.dart';

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

    // Thought Challenges table
    await db.execute('''
CREATE TABLE thoughtChallenges (
  id TEXT PRIMARY KEY,
  negativeThought TEXT NOT NULL,
  evidenceFor TEXT NOT NULL,
  evidenceAgainst TEXT NOT NULL,
  cognitiveReframingTechnique TEXT NOT NULL,
  reframedThought TEXT,
  progress REAL NOT NULL
)
''');

    await db.execute('''
CREATE TABLE userActivities (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  activityDate TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE progressPoints (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  thoughtChallengeId TEXT,
  progress REAL NOT NULL,
  FOREIGN KEY (thoughtChallengeId) REFERENCES thoughtChallenges (id)
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
      columns: [
        'id',
        'title',
        'description',
        'dueDate',
        'isCompleted',
        'priority'
      ],
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

  // CRUD for ThoughChallenge
  Future<ThoughtChallenge> createThoughtChallenge(ThoughtChallenge challenge) async {
    final db = await database;
    try {
      final json = challenge.toJson();
      await db.insert('thoughtChallenges', json);
      return challenge;
    } catch (e) {
      if (kDebugMode) {
        print("Database error: $e");
      }
      throw Exception('Failed to create challenge');
    }
  }

  Future<ThoughtChallenge?> readThoughtChallenge(String id) async {
    final db = await database;
    final maps =
        await db.query('thoughtChallenges', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ThoughtChallenge.fromJson(
          maps.first); // Assuming you have a fromJson constructor
    }
    return null;
  }

  Future<int> updateThoughtChallenge(ThoughtChallenge challenge) async {
    final db = await database;
    final json = challenge.toJson(); // Convert challenge object to JSON
    return await db.update(
      'thoughtChallenges',
      json,
      where: 'id = ?',
      whereArgs: [challenge.id],
    );
  }

  Future<int> deleteThoughtChallenge(String id) async {
    final db = await database;
    return await db.delete(
      'thoughtChallenges',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ThoughtChallenge>> getAllThoughtChallenges() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('thoughtChallenges');

    return List.generate(maps.length, (i) {
      return ThoughtChallenge.fromJson(
          maps[i]); // Convert each map to a ThoughtChallenge object
    });
  }

  Future<int> getUnlockedAchievementsCount() async {
    final db = await database;
    final result = await db.query(
      'achievements',
      where: 'isUnlocked = ?',
      whereArgs: [1],
    );
    return result.length;
  }

  Future<int> getCurrentStreak() async {
    final db = await database;
    DateTime currentDate = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) { // Safeguard loop to a year
      String dateStr = DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: i)));
      final result = await db.query(
        'userActivities',
        where: 'activityDate = ?',
        whereArgs: [dateStr],
      );
      if (result.isNotEmpty) {
        streak++;
      } else {
        break; // Break the loop if no activity found for the day
      }
    }

    return streak == 0 ? 4 : streak;
  }

  Future<List<double>> getProgressPoints({int count = 4}) async {
    final db = await database;
    final result = await db.query(
      'progressPoints',
      orderBy: 'id DESC',
      limit: count,
    );

    // If the result is empty, return a list with different placeholder values
    if (result.isEmpty) {
      // Define a list of different placeholder values
      List<double> placeholderValues = [70.0, 75.0, 65.0, 85.0, 80.0];
      // Ensure the list matches the desired count by repeating or trimming
      if (placeholderValues.length > count) {
        return placeholderValues.sublist(0, count);
      } else if (placeholderValues.length < count) {
        // If the predefined placeholders are fewer than count, repeat them
        while (placeholderValues.length < count) {
          placeholderValues.addAll(placeholderValues);
        }
        // Trim the list to the exact desired count
        return placeholderValues.sublist(0, count);
      }
      // If the placeholderValues length exactly matches count, return it directly
      return placeholderValues;
    }

    // If there is data, convert the result to a list of double values and return
    List<double> progressPoints = result.map<double>((row) => row['progress'] as double).toList().reversed.toList();

    // If the number of progress points is less than 'count', fill the rest with placeholder values
    int missingCount = count - progressPoints.length;
    if (missingCount > 0) {
      List<double> placeholders = [40.0, 65.0, 85.0, 75.0, 50.0].sublist(0, missingCount);
      progressPoints.addAll(placeholders); // Add placeholders to ensure the list has 'count' number of items
    }

    return progressPoints;
  }

  Future<void> updateProgress(String challengeId, double newProgress) async {
    final db = await database;
    await db.update(
      'thoughtChallenges',
      {'progress': newProgress},
      where: 'id = ?',
      whereArgs: [challengeId],
    );
  }

  Future<void> unlockAchievement(String achievementId) async {
    final db = await database;
    await db.update(
      'achievements',
      {'isUnlocked': 1},
      where: 'id = ?',
      whereArgs: [achievementId],
    );
  }

  // Remember to close the database to avoid memory leaks
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
