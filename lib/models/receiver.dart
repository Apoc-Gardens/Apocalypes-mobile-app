// models/receiver.dart
class Receiver {
  final int? id;
  final String name;
  final String mac;
  final int? lastSynced;

  Receiver({required this.id, required this.name, required this.mac,required this.lastSynced});

  // Convert a Device into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      //'lastsynced': lastSynced.toIso8601String(),
      'lastsynced': lastSynced,
    };
  }

  // Convert a Map into a Device. The keys must correspond to the column names in the database.
  factory Receiver.fromMap(Map<String, dynamic> map) {
    return Receiver(
      id: map['id'],
      name: map['name'],
      mac: map['mac'],
      lastSynced: map['lastsynced'],
    );
  }
}
