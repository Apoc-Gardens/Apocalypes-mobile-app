// models/device.dart
class Device {
  final int id;
  final String name;
  final DateTime lastSynced;

  Device({required this.id, required this.name, required this.lastSynced});

  // Convert a Device into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastsynced': lastSynced.toIso8601String(),
    };
  }

  // Convert a Map into a Device. The keys must correspond to the column names in the database.
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      lastSynced: DateTime.parse(map['lastsynced']),
    );
  }
}
