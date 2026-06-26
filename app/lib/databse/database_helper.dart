import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, "stuhub.db"),
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE session_config(
  id TEXT PRIMARY KEY,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,

  synced INTEGER DEFAULT 0,

  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE subjects(
  id TEXT PRIMARY KEY,

  name TEXT NOT NULL,

  required_attendance REAL DEFAULT 75,

  synced INTEGER DEFAULT 0,

  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE timetable(
  id TEXT PRIMARY KEY,

  subject_id TEXT NOT NULL,

  weekday INTEGER NOT NULL,

  class_count INTEGER DEFAULT 0,

  synced INTEGER DEFAULT 0,

  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE attendance(
  id TEXT PRIMARY KEY,
  subjectId TEXT NOT NULL,
  date TEXT NOT NULL,
  totalClasses INTEGER NOT NULL,
  attendedClasses INTEGER NOT NULL,
  status TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  UNIQUE(subjectId, date)
)
''');

    await db.execute('''
CREATE TABLE app_setup(
  id INTEGER PRIMARY KEY,

  session_completed INTEGER DEFAULT 0,

  subjects_completed INTEGER DEFAULT 0,

  timetable_completed INTEGER DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE user_profile(
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  profile_image TEXT,
  updated_at TEXT NOT NULL
)
''');

    await db.insert('app_setup', {
      'id': 1,
      'session_completed': 0,
      'subjects_completed': 0,
      'timetable_completed': 0,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
  CREATE TABLE user_profile(
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  profile_image TEXT,
  updated_at TEXT NOT NULL
) 
''');
    }
  }
}
