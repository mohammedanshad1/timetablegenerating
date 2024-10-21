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

  Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final db = await database;
    return await db.query('subjects');
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
  Future<void> printTable(String tableName) async {
  final db = await database;

  // Fetch rows from the specified table
  final List<Map<String, dynamic>> rows = await db.query(tableName);

  // Print each row
  for (var row in rows) {
    print(row);
  }
}
 Future<void> assignStaffToSubject(int staffId, int subjectId) async {
    final db = await database;
    await db.insert(
      'staffAssignment',
      {
        'staffId': staffId,
        'subjectId': subjectId,
      },
    );
  }

  // Method to print staff assignments
  Future<List<Map<String, dynamic>>> getStaffAssignments() async {
    final db = await database;
    return await db.query('staffAssignment');
  }
Future<List<Map<String, dynamic>>> getPeriodsForDay(int dayId) async {
  final db = await database;
  return await db.query('periods', where: 'dayId = ?', whereArgs: [dayId]);
}
Future<int> addPeriod({
  required int dayId,
  required int periodNumber,
  required String startTime,
  required String endTime,
  required int subjectId,
}) async {
  final db = await database;
  return await db.insert('periods', {
    'dayId': dayId,
    'periodNumber': periodNumber,
    'startTime': startTime,
    'endTime': endTime,
    'subjectId': subjectId,
  });
}

// Optional: Add this method to get subject details with staff information
Future<Map<String, dynamic>> getSubjectDetails(int subjectId) async {
  final db = await database;
  final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      s.name as subjectName,
      st.name as staffName
    FROM subjects s
    LEFT JOIN staffAssignment sa ON s.id = sa.subjectId
    LEFT JOIN staff st ON sa.staffId = st.id
    WHERE s.id = ?
  ''', [subjectId]);
  
  return results.isNotEmpty ? results.first : {};
}
}
