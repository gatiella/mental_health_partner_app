import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mental_health.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        username TEXT,
        profile_picture TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE conversations (
        id TEXT PRIMARY KEY,
        created_at INTEGER,
        last_message TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT,
        content TEXT,
        is_user_message INTEGER,
        created_at INTEGER,
        FOREIGN KEY(conversation_id) REFERENCES conversations(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE journals (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        mood TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE moods (
        id TEXT PRIMARY KEY,
        rating INTEGER,
        notes TEXT,
        created_at INTEGER
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
