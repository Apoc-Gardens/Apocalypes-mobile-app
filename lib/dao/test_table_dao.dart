import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/test_table.dart';

class TestTableDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertTestData(int deviceId, String name, String description) async {
    Database db = await _databaseHelper.database;
    return await db.insert('testtable', {
      'id': deviceId,
      'name': name,
      'description': description,
    });
  }

  Future<List<TestTable>> getAllTestTables() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('testtable');
    return List.generate(maps.length, (i) {
      return TestTable.fromMap(maps[i]);
    });
  }

  Future<int?> getCount() async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM testtable'));
  }

  Future<int?> getMax() async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(id) FROM testtable'));
  }
}
