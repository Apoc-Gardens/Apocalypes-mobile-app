// models/test_table.dart
class TestTable {
  final int id;
  final String name;
  final String? description;

  TestTable({required this.id, required this.name, this.description});

  factory TestTable.fromMap(Map<String, dynamic> map) {
    return TestTable(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
