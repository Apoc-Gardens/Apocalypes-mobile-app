// models/node.dart
class Node {
  final int id;
  late final String nid;
  final String name;
  final String? description;

  Node({
    required this.id,
    required this.nid,
    required this.name,
    required this.description,
  });

  // Convert a Node into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nid': nid,
      'name': name,
      'description': description,
    };
  }

  // Convert a Map into a Node. The keys must correspond to the column names in the database.
  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      id: map['id'],
      nid: map['nid'],
      name: map['name'],
      description: map['description'],
    );
  }
}
