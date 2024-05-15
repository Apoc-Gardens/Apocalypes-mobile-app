class Data {
  final int deviceId;
  final int dataTypeId;
  final double value;

  Data({required this.deviceId, required this.dataTypeId, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'device_id': deviceId,
      'datatype_id': dataTypeId,
      'value': value,
    };
  }
}