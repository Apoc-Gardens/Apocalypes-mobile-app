import 'package:flutter/material.dart';

class SensorCard extends StatefulWidget {
  const SensorCard({super.key});

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Border radius
        side: const BorderSide(
          color: Color(0xFFE4E4E4), // Border color
          width: 1.0, // Border thickness
        ),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0), // Padding
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Carrot Patch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            Text('Behind the main house',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.black
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Update'),
                    Text('6 min ago')
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No. Data'),
                    Text('300')
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            Divider(),
            Text('LATEST READINGS',
            style: TextStyle(
              color: Color(0xFF0AA061),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Temperarure'),
                    Text('30C')
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Humidity'),
                    Text('30%')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LUX'),
                    Text('15467')
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soil'),
                    Text('100%')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
