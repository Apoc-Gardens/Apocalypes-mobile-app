import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/datatype.dart';

class DataTypeDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<DataType>> getAllDataTypes() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('datatypes');
    return List.generate(maps.length, (i) {
      return DataType.fromMap(maps[i]);
    });
  }
}
