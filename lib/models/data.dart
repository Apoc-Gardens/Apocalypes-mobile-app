// models/data.dart
class Data {
  final int? id;
  final int nodeId;
  final int dataTypeId;
  final double value;
  final int timestamp;

  Data({
    this.id,
    required this.nodeId,
    required this.dataTypeId,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'node_id': nodeId,
      'datatype_id': dataTypeId,
      'value': value,
      'timestamp': timestamp,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      nodeId: map['node_id'],
      dataTypeId: map['datatype_id'],
      value: map['value'],
      timestamp: map['timestamp'],
    );
  }
}
