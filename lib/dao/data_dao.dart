import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/data.dart';

class DataDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertData(int nodeId, int dataTypeId, double value, int timestamp) async {
    Database db = await _databaseHelper.database;
    return await db.insert('data', {
      'node_id': nodeId,
      'datatype_id': dataTypeId,
      'value': value,
      'timestamp': timestamp
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Data>> getAllData() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('data');
    return List.generate(maps.length, (i) {
      return Data.fromMap(maps[i]);
    });
  }

  Future<List<Data>> getLatestReadings(String nodeid) async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM data WHERE node_id = ? ORDER BY timestamp DESC LIMIT 5', [nodeid]);
    return List.generate(maps.length, (i) {
      return Data.fromMap(maps[i]);
    });
  }

  Future<int?> countData(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM data WHERE node_id = ?', [dataNid]));
  }

  Future<int?> latestDataTimeStamp(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(timestamp) FROM data WHERE node_id = ?', [dataNid]));
  }

  Future<int?> oldestDataTimeStamp(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MIN(timestamp) FROM data WHERE node_id = ?', [dataNid]));
  }

  Future<List<Map<String, dynamic>>> getDataByNodeTime(String dataNid, int startTime, int endTime) async {
    Database db = await _databaseHelper.database;
    return await db.rawQuery('SELECT * FROM data WHERE node_id = ? AND (timestamp BETWEEN ? AND ?)', [dataNid, startTime, endTime]);
  }
}
