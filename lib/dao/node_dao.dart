import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/node.dart';

class NodeDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertNode(Node node) async {
    Database db = await _databaseHelper.database;
    int? newNodeId;
    if(node.id < 0){
      newNodeId = null;
    }else{
      newNodeId = node.id;
    }

    return await db.insert('nodes', {
      'id': newNodeId,
      'nid': node.nid,
      'name': node.name,
      'description': node.description,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int?> getNodeCount() async {
    Database db = await _databaseHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(id) FROM nodes'));
  }

  Future<List<Map<String, dynamic>>> getNodeById(String nid) async {
    Database db = await _databaseHelper.database;
    return await db.rawQuery('SELECT id FROM nodes WHERE nid = ?', [nid]);
  }

  Future<List<Node>> getAllNodes() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('nodes');
    return List.generate(maps.length, (i) {
      return Node.fromMap(maps[i]);
    });
  }

  Future<int> updateNodeName(String tableId, String name) async {
    Database db = await _databaseHelper.database;
    return await db.rawUpdate('UPDATE nodes SET name = ? WHERE id = ?', [name, tableId]);
  }

  Future<int> updateNodeDescription(String tableId, String description) async {
    Database db = await _databaseHelper.database;
    return await db.rawUpdate('UPDATE nodes SET description = ? WHERE id = ?', [description, tableId]);
  }

  Future<int> updateNodeDetails(String tableId, String field, String value) async {
    Database db = await _databaseHelper.database;
    return await db.rawUpdate('UPDATE nodes SET $field = ? WHERE id = ?', [value, tableId]);
  }

  Future<Map<String, int>> getNodeMap() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('nodes');
    final Map<String, int> nodeMap = {};
    for (Map<String, dynamic> map in maps) {
      nodeMap[map['nid']] = map['id'];
    }
    return nodeMap;
  }
}
