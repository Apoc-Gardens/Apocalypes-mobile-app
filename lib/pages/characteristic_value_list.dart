import 'package:flutter/material.dart';

class CharacteristicValueListPage extends StatelessWidget {
  final List<String> characteristicValues;

  const CharacteristicValueListPage({super.key, required this.characteristicValues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characteristic Values'),
      ),
      body: ListView.builder(
        itemCount: characteristicValues.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(characteristicValues[index]),
          );
        },
      ),
    );
  }
}
