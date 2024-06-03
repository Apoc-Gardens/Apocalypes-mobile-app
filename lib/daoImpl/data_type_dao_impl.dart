import 'package:mybluetoothapp/dao/data_type_dao.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/services/database_service.dart';

class DataTypeDaoImpl extends DataTypeDao {

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Future<void> deleteDataType(int id) async {
    final db = _databaseHelper.database;
    db.then((value) => value.delete(
      'datatypes',
      where: 'id = ?',
      whereArgs: [id],
    ));
  }

  @override
  Future<void> deleteDataTypeList(List<int> idList) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'datatypes',
      where: 'id IN (?)',
      whereArgs: [idList],
    );
  }

  @override
  Future<DataType> getDataType(int id) async{
    final db = _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.then((value) => value.query(
      'datatypes',
      where: 'id = ?',
      whereArgs: [id],
    ));

    return DataType.fromMap(maps[0]);
  }

  @override
  Future<DataType> getDataTypeByName (String name) async{
    final db = _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.then((value) => value.query(
      'datatypes',
      where: 'name = ?',
      whereArgs: [name],
    ));
    return DataType.fromMap(maps[0]);
  }

  @override
  Future<List<DataType>> getDataTypes() async{
    final db = _databaseHelper.database;
    final List<Map<String, dynamic>> maps = db.then((value) => value.query('datatypes')) as List<Map<String, dynamic>>;
    return List.generate(maps.length, (i) {
      return DataType.fromMap(maps[i]);
    });

  }

  @override
  Future<void> insertDataType(DataType dataType) async{
    final db = _databaseHelper.database;
    db.then((value) => value.insert(
      'datatypes',
      dataType.toMap(),
    ));
  }

  @override
  Future<void> insertDataTypeList(List<DataType> dataTypeList) async{
    final db = _databaseHelper.database;
    db.then((value) => value.rawQuery('INSERT INTO datatypes VALUES (?)', [dataTypeList]));
  }

  @override
  Future<void> updateDataType(DataType dataType) async{
    final db = _databaseHelper.database;
    db.then((value) => value.update(
      'datatypes',
      dataType.toMap(),
      where: 'id = ?',
      whereArgs: [dataType.id],
    ));
  }

  @override
  Future<void> updateDataTypeList(List<DataType> dataTypeList) async{
    final db = _databaseHelper.database;
    db.then((value) => value.rawQuery('UPDATE datatypes SET (?) WHERE id = ?', [dataTypeList]));
  }
}