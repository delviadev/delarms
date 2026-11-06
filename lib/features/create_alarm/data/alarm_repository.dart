import 'package:delarms/features/create_alarm/data/alarm_database.dart';
import 'package:delarms/features/create_alarm/data/alarm_model.dart';
import 'package:sqflite/sqflite.dart';

class AlarmRepository {
  AlarmRepository({AlarmDatabase? database})
    : _database = database ?? AlarmDatabase.instance;

  static final AlarmRepository instance = AlarmRepository();

  final AlarmDatabase _database;

  Future<int> createAlarm(Alarm alarm) async {
    final db = await _database.database;
    return db.insert(
      AlarmDatabase.tableAlarms,
      alarm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Alarm>> getAllAlarms() async {
    final db = await _database.database;
    final rows = await db.query(
      AlarmDatabase.tableAlarms,
      orderBy: 'hour ASC, minute ASC',
    );
    return rows.map(Alarm.fromMap).toList();
  }

  Future<Alarm?> getAlarmById(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      AlarmDatabase.tableAlarms,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : Alarm.fromMap(rows.first);
  }

  Future<int> updateAlarm(Alarm alarm) async {
    final id = alarm.id;
    if (id == null) {
      throw ArgumentError.value(alarm.id, 'alarm.id', 'Must not be null');
    }

    final db = await _database.database;
    return db.update(
      AlarmDatabase.tableAlarms,
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> setAlarmActive(int id, bool isActive) async {
    final db = await _database.database;
    return db.update(
      AlarmDatabase.tableAlarms,
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAlarm(int id) async {
    final db = await _database.database;
    return db.delete(
      AlarmDatabase.tableAlarms,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
