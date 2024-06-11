import 'package:flutter/material.dart';

class CharacteristicValuePage extends StatelessWidget {
  final String characteristicValue;

  const CharacteristicValuePage({required this.characteristicValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characteristic Value'),
      ),
      body: Center(
        child: Text(characteristicValue),
      ),
    );
  }
}
