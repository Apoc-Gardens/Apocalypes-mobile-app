import 'package:flutter/material.dart';
import 'package:mybluetoothapp/widgets/Sync_card.dart';
import 'package:mybluetoothapp/widgets/sensor_card.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sensors',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'inter',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0AA061), side: const BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0), // Border radius
                      ),
                      padding: const EdgeInsets.all(6.0), // Padding
                    ),
                    child: const Text('Add sensor'),
                  ),
                ],
            ),
            const SensorCard(),
            const SyncCard()
          ],
        ),
      ),
    );
  }
}
