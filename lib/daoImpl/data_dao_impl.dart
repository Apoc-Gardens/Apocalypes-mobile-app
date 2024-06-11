import 'package:mybluetoothapp/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/data_dao.dart';
import '../models/data.dart';

class DataDaoImpl extends DataDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Data>> getData() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('data');
    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<void> deleteAllData() async {
    final db = await _databaseHelper.database;
    await db.delete('data');
  }

  @override
  Future<void> deleteData(int id) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteDataList(List<int> idList) async {
    final db = await _databaseHelper.database;

    await db.delete(
      'data',
      where: 'id IN (?)',
      whereArgs: [idList],
    );
  }

  @override
  Future<Data> getDataById(int id) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps =
        await db.query('data', where: 'id = ?', whereArgs: [id]);

    return Data(
      id: maps[0]['id'],
      nodeId: maps[0]['node_id'],
      dataTypeId: maps[0]['datatype_id'],
      value: maps[0]['value'],
      timestamp: maps[0]['timestamp'],
    );
  }

  @override
  Future<List<Data>> getDataInTimeRange(int startTime, int endTime) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('data',
        where: 'timestamp >= ? AND timestamp <= ?',
        whereArgs: [startTime, endTime]);

    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<List<Data>> getDataInTimeRangeByDataTypeId(
      int dataTypeId, int startTime, int endTime) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('data',
        where: 'datatype_id = ? AND timestamp >= ? AND timestamp <= ?',
        whereArgs: [dataTypeId, startTime, endTime]);
    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<List<Data>> getDataInTimeRangeByNodeId(
      int nodeId, int startTime, int endTime) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('data',
        where: 'node_id = ? AND timestamp >= ? AND timestamp <= ?',
        whereArgs: [nodeId, startTime, endTime]);
    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<List<Data>> getDataInTimeRangeByNodeIdAndDataTypeId(
      int nodeId, int dataTypeId, int startTime, int endTime) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('data',
        where:
            'node_id = ? AND datatype_id = ? AND timestamp >= ? AND timestamp <= ?',
        whereArgs: [nodeId, dataTypeId, startTime, endTime]);
    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<List<Data>> getDataListByIdList(List<int> idList) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps =
        await db.query('data', where: 'id IN (?)', whereArgs: [idList]);
    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        nodeId: maps[i]['node_id'],
        dataTypeId: maps[i]['datatype_id'],
        value: maps[i]['value'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  @override
  Future<void> insertData(Data data) async {
    final db = await _databaseHelper.database;

    await db.insert(
      'data',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertDataList(List<Data> dataList) async {
    final db = await _databaseHelper.database;

    final batch = db.batch();
    for (final data in dataList) {
      batch.insert(
        'data',
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateData(Data data) async {
    final db = await _databaseHelper.database;

    await db.update(
      'data',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  @override
  Future<void> updateDataList(List<Data> dataList) async {
    final db = await _databaseHelper.database;

    final batch = db.batch();
    for (final data in dataList) {
      batch.update(
        'data',
        data.toMap(),
        where: 'id = ?',
        whereArgs: [data.id],
      );
    }
  }

  @override
  Future<List<Data>> getLatestReadings(String nodeId) async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM data WHERE node_id = ? ORDER BY timestamp DESC LIMIT 5', [nodeId]);
    return List.generate(maps.length, (i) {
      return Data.fromMap(maps[i]);
    });
  }

  @override
  Future<int?> countData(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM data WHERE node_id = ?', [dataNid]));
  }

  @override
  Future<int?> latestDataTimeStamp(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(timestamp) FROM data WHERE node_id = ?', [dataNid]));
  }
@override
  Future<int?> oldestDataTimeStamp(String dataNid) async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MIN(timestamp) FROM data WHERE node_id = ?', [dataNid]));
  }
}
