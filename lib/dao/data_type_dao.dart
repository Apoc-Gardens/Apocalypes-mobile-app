import '../models/datatype.dart';

/// An abstract class that defines the methods for managing `DataType` objects.
/// This class provides methods for inserting, updating, deleting, and querying `DataType` records.
abstract class DataTypeDao {

/// Inserts a new `DataType` into the database.
///
/// This method takes a [DataType] object as a parameter and inserts it into the database.
/// The method returns a `Future` which completes when the insertion is done.
///
/// [dataType] The `DataType` object to be inserted.
Future<void> insertDataType(DataType dataType);

/// Updates an existing `DataType` in the database.
///
/// This method takes a [DataType] object as a parameter and updates the corresponding record
/// in the database. The method returns a `Future` which completes when the update is done.
///
/// [dataType] The `DataType` object with updated values.
Future<void> updateDataType(DataType dataType);

/// Deletes a `DataType` from the database.
///
/// This method takes an [id] as a parameter and deletes the corresponding `DataType` record
/// from the database. The method returns a `Future` which completes when the deletion is done.
///
/// [id] The ID of the `DataType` to be deleted.
Future<void> deleteDataType(int id);

/// Retrieves all `DataType` objects from the database.
///
/// This method returns a `Future` that completes with a list of all `DataType` objects
/// present in the database.
///
/// Returns a `Future<List<DataType>>` containing all `DataType` objects.
Future<List<DataType>> getDataTypes();

/// Retrieves a `DataType` object by its ID.
///
/// This method takes an [id] as a parameter and returns a `Future` that completes
/// with the corresponding `DataType` object.
///
/// [id] The ID of the `DataType` to be retrieved.
/// Returns a `Future<DataType>` containing the `DataType` object with the specified ID.
Future<DataType> getDataType(int id);

/// Retrieves a `DataType` object by its name.
///
/// This method takes a [name] as a parameter and returns a `Future` that completes
/// with the corresponding `DataType` object.
///
/// [name] The name of the `DataType` to be retrieved.
/// Returns a `Future<DataType>` containing the `DataType` object with the specified name.
Future<DataType> getDataTypeByName(String name);

/// Inserts a list of `DataType` objects into the database.
///
/// This method takes a list of [dataTypeList] as a parameter and inserts each `DataType`
/// into the database. The method returns a `Future` which completes when all insertions are done.
///
/// [dataTypeList] A list of `DataType` objects to be inserted.
Future<void> insertDataTypeList(List<DataType> dataTypeList);

/// Updates a list of `DataType` objects in the database.
///
/// This method takes a list of [dataTypeList] as a parameter and updates each corresponding
/// `DataType` record in the database. The method returns a `Future` which completes when all updates are done.
///
/// [dataTypeList] A list of `DataType` objects with updated values.
Future<void> updateDataTypeList(List<DataType> dataTypeList);

/// Deletes a list of `DataType` objects from the database by their IDs.
///
/// This method takes a list of [idList] as a parameter and deletes each corresponding
/// `DataType` record from the database. The method returns a `Future` which completes when all deletions are done.
///
/// [idList] A list of IDs of the `DataType` objects to be deleted.
Future<void> deleteDataTypeList(List<int> idList);
}
