import 'package:flutter/material.dart';

class SyncCard extends StatefulWidget {
  const SyncCard({super.key});

  @override
  State<SyncCard> createState() => _SyncCardState();
}

class _SyncCardState extends State<SyncCard> {
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
        color: const Color(0xFFCDE8DD),
        padding: const EdgeInsets.all(16.0), // Padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Receiver',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    Text('last sync 6 min ago',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                    ),
                  ],
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
                  child: const Text('Sync Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
