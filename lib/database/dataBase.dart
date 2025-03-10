import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;

    try {
      _db = await getDatabase();
      return _db!;
    } catch (e) {
      print("Database Initialization Failed: $e");
      throw Exception("Database Initialization Failed");
    }
  }


  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "reader_pro.db");

    Database database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE ReaderPro(name TEXT PRIMARY KEY, content TEXT)',
        );
      },
    );
    return database;
  }

  Future<void> insert(String name, String content) async {
    final db = await getDatabase();

    await db.insert (
      'ReaderPro',
      {'name': name, 'content': content},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllRecord() async {
    final Database db = await getDatabase();

    return await db.query('ReaderPro');
  }

  Future<Map<String, dynamic>?> getSingleRecord(String name) async {
    final Database db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query(
      'ReaderPro',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
