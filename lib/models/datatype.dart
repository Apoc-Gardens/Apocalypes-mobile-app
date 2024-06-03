// models/datatype.dart
class DataType {
  final int id;
  final String name;
  final String unit;
  final String information;

  DataType(
      {required this.id,
      required this.name,
      required this.unit,
      this.information = ''});

  // Convert a DataType into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'information': information,
    };
  }

  // Convert a Map into a DataType. The keys must correspond to the column names in the database.
  factory DataType.fromMap(Map<String, dynamic> map) {
    return DataType(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      information: map['information'],
    );
  }
}
