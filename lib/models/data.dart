// models/data.dart
class Data {
  final int id;
  final int deviceId;
  final int dataTypeId;
  final double value;

  Data({required this.id, required this.deviceId, required this.dataTypeId, required this.value});

  // Convert a Data into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'device_id': deviceId,
      'datatype_id': dataTypeId,
      'value': value,
    };
  }

  // Convert a Map into a Data. The keys must correspond to the column names in the database.
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      deviceId: map['device_id'],
      dataTypeId: map['datatype_id'],
      value: map['value'],
    );
  }
}
