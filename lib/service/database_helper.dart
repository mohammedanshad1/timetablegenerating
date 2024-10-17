import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'timetable.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE subjects(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            courseId INTEGER,
            FOREIGN KEY(courseId) REFERENCES courses(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE staff(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE staffAssignment(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            staffId INTEGER,
            subjectId INTEGER,
            FOREIGN KEY(staffId) REFERENCES staff(id),
            FOREIGN KEY(subjectId) REFERENCES subjects(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE days(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE periods(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dayId INTEGER,
            periodNumber INTEGER,
            startTime TEXT,
            endTime TEXT,
            subjectId INTEGER,
            FOREIGN KEY(dayId) REFERENCES days(id),
            FOREIGN KEY(subjectId) REFERENCES subjects(id)
          );
        ''');

        await _initializeDays(db);
      },
      version: 1,
    );
  }

  Future<void> _initializeDays(Database db) async {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    for (String day in days) {
      await db.insert('days', {'name': day});
    }
  }

  Future<int> addCourse(String name) async {
    final db = await database;
    return await db.insert('courses', {'name': name});
  }

  Future<void> deleteCourse(int id) async {
    final db = await database;
    await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> addSubject(String name, int courseId) async {
    final db = await database;
    return await db.insert('subjects', {'name': name, 'courseId': courseId});
  }

  Future<void> deleteSubject(int id) async {
    final db = await database;
    await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> addStaff(String name) async {
    final db = await database;
    return await db.insert('staff', {'name': name});
  }
Future<void> deleteStaff(int id) async {
  final db = await database;
  await db.delete('staff', where: 'id = ?', whereArgs: [id]);
}

  Future<int> addDay(String name) async {
    final db = await database;
    return await db.insert('days', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await database;
    return await db.query('courses');
  }

  Future<List<Map<String, dynamic>>> getSubjects(int courseId) async {
    final db = await database;
    return await db
        .query('subjects', where: 'courseId = ?', whereArgs: [courseId]);
  }

  Future<List<Map<String, dynamic>>> getStaff() async {
    final db = await database;
    return await db.query('staff');
  }

  Future<List<Map<String, dynamic>>> getDays() async {
    final db = await database;
    return await db.query('days');
  }
}
