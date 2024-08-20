import '../models/data.dart';

/// Abstract class that defines methods for interacting with data.
///
/// This class provides methods for CRUD (Create, Read, Update, Delete) operations
/// on data objects. It also offers functionalities for retrieving data based on specific criteria
/// like time range, node ID, and data type ID.
abstract class DataDao {
  /// Retrieves a list of all data objects.
  ///
  /// This method fetches all data objects from the underlying storage.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of data objects.
  Future<List<Data>> getData();

  /// Inserts a new data object into the storage.
  ///
  /// This method takes a `Data` object and adds it to the underlying storage.
  ///
  /// Args:
  ///   data: The `Data` object to be inserted.
  ///
  /// Returns: A `Future<void>` that completes after the insertion is done.
  Future<void> insertData(Data data);

  /// Updates an existing data object in the storage.
  ///
  /// This method takes a `Data` object and updates the corresponding record in the storage.
  ///
  /// Args:
  ///   data: The `Data` object with updated information.
  ///
  /// Returns: A `Future<void>` that completes after the update is done.
  Future<void> updateData(Data data);

  /// Deletes a data object from the storage based on its ID.
  ///
  /// This method takes an `int` representing the ID of the data object to be deleted.
  ///
  /// Args:
  ///   id: The ID of the data object to be deleted.
  ///
  /// Returns: A `Future<void>` that completes after the deletion is done.
  Future<void> deleteData(int id);

  /// Inserts a list of data objects into the storage in a single transaction.
  ///
  /// This method improves efficiency by inserting multiple data objects at once.
  ///
  /// Args:
  ///   dataList: A `List<Data>` containing the data objects to be inserted.
  ///
  /// Returns: A `Future<void>` that completes after the insertion is done.
  Future<void> insertDataList(List<Data> dataList);

  /// Updates a list of data objects in the storage in a single transaction.
  ///
  /// This method improves efficiency by updating multiple data objects at once.
  ///
  /// Args:
  ///   dataList: A `List<Data>` containing the data objects with updated information.
  ///
  /// Returns: A `Future<void>` that completes after the update is done.
  Future<void> updateDataList(List<Data> dataList);

  /// Deletes a list of data objects from the storage based on their IDs.
  ///
  /// This method takes a `List<int>` containing the IDs of the data objects to be deleted.
  ///
  /// Args:
  ///   idList: A `List<int>` containing the IDs of the data objects to be deleted.
  ///
  /// Returns: A `Future<void>` that completes after the deletion is done.
  Future<void> deleteDataList(List<int> idList);

  /// Deletes all data objects from the storage.
  ///
  /// This method removes all data objects from the underlying storage.
  ///
  /// Returns: A `Future<void>` that completes after the deletion is done.
  Future<void> deleteAllData();

  /// Retrieves a specific data object based on its ID.
  ///
  /// This method takes an `int` representing the ID of the data object to be retrieved.
  ///
  /// Args:
  ///   id: The ID of the data object to be retrieved.
  ///
  /// Returns: A `Future<Data>` containing the retrieved data object, or `null` if not found.
  Future<Data> getDataById(int id);

  /// Retrieves a list of data objects based on a list of IDs.
  ///
  /// This method takes a `List<int>` containing the IDs of the data objects to be retrieved.
  ///
  /// Args:
  ///   idList: A `List<int>` containing the IDs of the data objects to be retrieved.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of retrieved data objects.
  Future<List<Data>> getDataListByIdList(List<int> idList);

  /// Retrieves a list of data objects within a specified time range.
  ///
  /// This method fetches data objects where the `timestamp` falls between the provided `startTime` (inclusive) and `endTime` (inclusive) timestamps.
  ///
  /// Args:
  ///   startTime: The starting timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///   endTime: The ending timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of data objects within the specified time range.
  ///   If no data exists within the range, an empty list will be returned.
  Future<List<Data>> getDataInTimeRange(int startTime, int endTime);

  /// Retrieves a list of data objects within a specified time range, filtered by data type ID.
  ///
  /// This method fetches data objects where the `timestamp` falls between the provided `startTime` (inclusive) and `endTime` (inclusive) timestamps
  /// and the `dataTypeId` matches the provided value.
  ///
  /// Args:
  ///   dataTypeId: The ID of the data type to filter by.
  ///   startTime: The starting timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///   endTime: The ending timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of data objects that match the data type ID and fall within the specified time range.
  ///   If no data exists that meets the criteria, an empty list will be returned.
  Future<List<Data>> getDataInTimeRangeByDataTypeId(int dataTypeId,
      int startTime, int endTime);

  /// Retrieves a list of data objects within a specified time range, filtered by node ID.
  ///
  /// This method fetches data objects where the `timestamp` falls between the provided `startTime` (inclusive) and `endTime` (inclusive) timestamps
  /// and the `nodeId` matches the provided value.
  ///
  /// Args:
  ///   nodeId: The ID of the node to filter by.
  ///   startTime: The starting timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///   endTime: The ending timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of data objects that match the node ID and fall within the specified time range.
  ///   If no data exists that meets the criteria, an empty list will be returned.
  Future<List<Data>> getDataInTimeRangeByNodeId(int nodeId, int startTime,
      int endTime);

  /// Retrieves a list of data objects within a specified time range, filtered by node ID and data type ID.
  ///
  /// This method fetches data objects where the `timestamp` falls between the provided `startTime` (inclusive) and `endTime` (inclusive) timestamps,
  ///
  /// Args:
  ///  nodeId: The ID of the node to filter by.
  /// dataTypeId: The ID of the data type to filter by.
  /// startTime: The starting timestamp (inclusive) of the desired time range in milliseconds since epoch.
  /// endTime: The ending timestamp (inclusive) of the desired time range in milliseconds since epoch.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of data objects that match the node ID, data type ID, and fall within the specified time range.
  /// If no data exists that meets the criteria, an empty list will be returned.
  Future<List<Data>> getDataInTimeRangeByNodeIdAndDataTypeId(int nodeId,
      int dataTypeId, int startTime, int endTime);

  /// Retrieves the latest readings for a specified node ID.
  ///
  /// This method fetches the most recent data objects for the given node ID.
  ///
  /// Args:
  ///   nodeId: The ID of the node to filter by.
  ///
  /// Returns: A `Future<List<Data>>` containing the list of the latest data objects for the specified node ID.
  /// If no data exists for the node ID, an empty list will be returned.
  Future<List<Data>> getLatestReadings(String nodeId);

  /// Counts the number of data objects for a specified data node ID.
  ///
  /// This method returns the total count of data objects associated with the given data node ID.
  ///
  /// Args:
  ///   dataNid: The ID of the data node to count the data objects for.
  ///
  /// Returns: A `Future<int?>` representing the total count of data objects for the specified data node ID.
  /// If no data exists for the data node ID, null will be returned.
  Future<int?> countData(String dataNid);

  /// Retrieves the latest timestamp for data objects associated with a specified data node ID.
  ///
  /// This method returns the timestamp of the most recent data object for the given data node ID.
  ///
  /// Args:
  ///   dataNid: The ID of the data node to get the latest timestamp for.
  ///
  /// Returns: A `Future<int?>` representing the timestamp (in milliseconds since epoch) of the latest data object for the specified data node ID.
  /// If no data exists for the data node ID, null will be returned.
  Future<int?> latestDataTimeStamp(String dataNid);

  /// Retrieves the oldest timestamp for data objects associated with a specified data node ID.
  ///
  /// This method returns the timestamp of the oldest data object for the given data node ID.
  ///
  /// Args:
  ///   dataNid: The ID of the data node to get the oldest timestamp for.
  ///
  /// Returns: A `Future<int?>` representing the timestamp (in milliseconds since epoch) of the oldest data object for the specified data node ID.
  /// If no data exists for the data node ID, null will be returned.
  Future<int?> oldestDataTimeStamp(String dataNid);

  ///This weill return the oldest time stamp of the data in the table
  Future<int?> latestDataTimeStampOverall();
}

