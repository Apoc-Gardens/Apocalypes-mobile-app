import 'package:mybluetoothapp/models/node.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../models/data.dart';
import '../models/datatype.dart';
import '../models/receiver.dart';
import '../models/test_table.dart';

class DatabaseHelper {
  static const _databaseName = "my_database.db";
  static const _databaseVersion = 1;

  static const tableReceivers = 'receivers';
  static const receiverTableId = 'id';
  static const receiverName = 'name';
  static const macAddress = 'mac';
  static const deviceLastSynced = 'lastsynced';

  static const tableSensorNodes = 'nodes';
  static const nodeTableId = 'id';
  static const nodeId = 'nid';
  static const nodeName = 'name';
  static const nodeDescription = 'description';
  static const nodeReceiverId = 'receiverid';

  static const tableDataTypes = 'datatypes';
  static const dataTypeId = 'id';
  static const dataTypeName = 'name';
  static const dataTypeUnit = 'unit';

  static const tableTestTable = 'testtable';
  static const testTableId = 'id';
  static const testTableName = 'name';
  static const testTableDescription = 'desctiption';

  static const tableData = 'data';
  static const dataId = 'id';
  static const dataNodeId = 'node_id';
  static const dataDataTypeId = 'datatype_id';
  static const dataValue = 'value';
  static const dataTimeStamp = 'timestamp';

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableReceivers (
        $receiverTableId INTEGER PRIMARY KEY AUTOINCREMENT,
        $receiverName TEXT NOT NULL,
        $deviceLastSynced DATETIME,
        $macAddress TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSensorNodes (
        $nodeTableId INTEGER PRIMARY KEY AUTOINCREMENT,
        $nodeId TEXT NOT NULL UNIQUE,
        $nodeName TEXT NOT NULL,
        $nodeDescription TEXT,
        $nodeReceiverId INTEGER,
        FOREIGN KEY ($nodeReceiverId) REFERENCES $tableReceivers ($receiverTableId) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableDataTypes (
        $dataTypeId INTEGER PRIMARY KEY,
        $dataTypeName TEXT NOT NULL,
        $dataTypeUnit TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTestTable (
        $testTableId INTEGER PRIMARY KEY,
        $testTableName TEXT NOT NULL,
        $testTableDescription TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableData (
        $dataId INTEGER PRIMARY KEY AUTOINCREMENT,
        $dataNodeId INTEGER NOT NULL,
        $dataDataTypeId INTEGER NOT NULL,
        $dataValue REAL,
        $dataTimeStamp INTEGER,
        FOREIGN KEY ($dataNodeId) REFERENCES $tableSensorNodes ($nodeTableId) ON DELETE CASCADE,
        FOREIGN KEY ($dataDataTypeId) REFERENCES $tableDataTypes ($dataTypeId) ON DELETE CASCADE,
        UNIQUE($dataNodeId, $dataDataTypeId, $dataValue, $dataTimeStamp)
      )
    ''');

    // Insert initial data into datatypes table
    await db.insert('datatypes', {'id': 1, 'name': 'Temperature', 'unit': 'C'});
    await db.insert('datatypes', {'id': 2, 'name': 'Humidity', 'unit': '%'});
    await db.insert('datatypes', {'id': 3, 'name': 'Light intensity', 'unit': 'Lux'});
    await db.insert('datatypes', {'id': 4, 'name': 'Soil moisture', 'unit': '%'});
    //await db.insert(tableReceivers, {'id': 1, 'name': 'ESP32', 'mac':'C8:F0:9F:F1:43:FE', 'lastsynced': null });
  }

  // CRUD operations below have been separated into DAOs, ToDo: remove them later

  //CRUD for devices

  Future<int> insertReceiverDevice(int? id, String name, String mac, String? lastsynced) async {
    Database db = await instance.database;
    return await db.insert(tableReceivers, {'id': id, 'name': name, 'mac': mac, 'lastsynced': lastsynced}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateLastSync(int id, int timestamp) async{
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $tableReceivers SET $deviceLastSynced = ? WHERE $nodeTableId = ?', [timestamp,id]);
  }

  Future<int?> getReceiverCount() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM $tableReceivers'));
  }

  Future<int> insertNode(Node node) async {
    Database db = await instance.database;
    return await db.insert(tableSensorNodes, node.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int?> getNodeCount() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM $tableSensorNodes'));
  }

  Future<List<Map<String, dynamic>>> getNodeById(String nid) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT $nodeTableId FROM $tableSensorNodes WHERE $nodeId = ?',[nid]);
  }

  Future<List<Receiver>> getAllDevices() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('receivers');
    return List.generate(maps.length, (i) {
      return Receiver.fromMap(maps[i]);
    });
  }

  Future<int> updateNodeName(String tableId, String name) async{
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $tableSensorNodes SET $nodeName = ? WHERE $nodeTableId = ?', [name,tableId]);
  }

  Future<int> updateNodeDescription(String tableId, String description) async{
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $tableSensorNodes SET $nodeDescription = ? WHERE $nodeTableId = ?', [description,tableId]);
  }

  Future<int> updateNodeDetails(String tableId, String field, String value) async{
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $tableSensorNodes SET ? = ? WHERE $nodeTableId = ?', [field,value,tableId]);
  }

  Future<List<Node>> getAllNodes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('nodes');
    return List.generate(maps.length, (i) {
      return Node.fromMap(maps[i]);
    });
  }

  Future<Map<String, int>> getNodeMap() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('nodes');
    final Map<String, int> nodeMap = {};
    for (Map<String,dynamic> map in maps) {
      nodeMap[map[nodeId]] = map[nodeTableId];
    }
    return nodeMap;
  }

  Future<int> insertData(int nodeId, int dataTypeId, double value, int timestamp) async {
    Database db = await instance.database;
    return await db.insert(tableData, {
      dataNodeId: nodeId,
      dataDataTypeId: dataTypeId,
      dataValue: value,
      dataTimeStamp: timestamp
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<DataType>> getAllDataTypes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('datatypes');
    return List.generate(maps.length, (i) {
      return DataType.fromMap(maps[i]);
    });
  }

  Future<List<Data>> getAllData() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('data');
    return List.generate(maps.length, (i) {
      return Data.fromMap(maps[i]);
    });
  }

  Future<List<Data>> getLatestReadings(String nodeid) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $tableData WHERE $dataNodeId = ? ORDER BY $dataTimeStamp DESC LIMIT 5',[nodeid]);
    return List.generate(maps.length, (i) {
      return Data.fromMap(maps[i]);
    });
  }

  Future<int?> countData(String dataNid) async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM $tableData WHERE $dataNodeId = ?',[dataNid]));
  }

  Future<int?> latestDataTimeStamp(String dataNid) async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MAX($dataTimeStamp) FROM $tableData WHERE $dataNodeId = ?',[dataNid]));
  }

  Future<int?> oldestDataTimeStamp(String dataNid) async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MIN($dataTimeStamp) FROM $tableData WHERE $dataNodeId = ?',[dataNid]));
  }

  Future<List<Map<String, dynamic>>> getDataByNodeTime(String dataNid, int startTime, int endTime) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableData WHERE $dataNodeId = ? AND ($dataTimeStamp  BETWEEN ? AND ?)',[dataNid, startTime, endTime]);
  }

  Future<void> insertMultipleData(List<Data> dataList) async {
    //not complete
    Database db = await instance.database;
    await db.rawQuery('INSERT INTO $tableData VALUES ($dataNodeId,$dataDataTypeId,$dataValue,$dataTimeStamp) ');
  }

  Future<int> insertTestData(int deviceId, String name, String description) async {
    Database db = await instance.database;
    return await db.insert(tableTestTable, {
      testTableId: deviceId,
      testTableName: name,
      testTableDescription: description,
    });
  }

  Future<List<TestTable>> getAllTestTables() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('testtable');

    return List.generate(maps.length, (i) {
      return TestTable.fromMap(maps[i]);
    });
  }

  Future<int?> getCount() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM testtable'));
  }

  Future<int?> getMax() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(id) FROM testtable'));
  }
}
