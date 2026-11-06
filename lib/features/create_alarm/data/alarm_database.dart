import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AlarmDatabase {
  static const String _dbName = 'alarm_app.db';
  static const int _dbVersion = 2;
  static const String tableAlarms = 'alarms';

  static final AlarmDatabase instance = AlarmDatabase._init();
  static Database? _database;

  AlarmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAlarms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        label TEXT NOT NULL,
        repeat_days TEXT NOT NULL,
        pre_alarm_enabled INTEGER NOT NULL,
        pre_alarm_minutes INTEGER NOT NULL,
        qr_image_path TEXT,
        is_active INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableAlarms ADD COLUMN qr_image_path TEXT',
      );
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
