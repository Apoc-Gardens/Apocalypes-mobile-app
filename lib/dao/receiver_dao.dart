import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/receiver.dart';

class ReceiverDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertReceiverDevice(int? id, String name, String mac, String? lastsynced) async {
    Database db = await _databaseHelper.database;
    return await db.insert('receivers', {'id': id, 'name': name, 'mac': mac, 'lastsynced': lastsynced}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateLastSync(int id, int timestamp) async {
    Database db = await _databaseHelper.database;
    return await db.rawUpdate('UPDATE receivers SET lastsynced = ? WHERE id = ?', [timestamp, id]);
  }

  Future<int> updateReceiverName(int id, String name) async {
    Database db = await _databaseHelper.database;
    return await db.rawUpdate('UPDATE receivers SET name = ? WHERE id = ?', [name, id]);
  }

  Future<int?> getReceiverCount() async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM receivers'));
  }

  Future<List<Receiver>> getAllDevices() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('receivers');
    return List.generate(maps.length, (i) {
      return Receiver.fromMap(maps[i]);
    });
  }

  Future<List<Receiver>> getDeviceById(int receiverId) async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM receivers WHERE id = ?',[receiverId]);
    return List.generate(maps.length, (i) {
      return Receiver.fromMap(maps[i]);
    });
  }
}
