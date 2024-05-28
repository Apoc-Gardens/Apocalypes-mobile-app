import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/node.dart';

class ViewSensor extends StatefulWidget {
  //final Node node;
  const ViewSensor({super.key, /*required this.node*/});

  @override
  State<ViewSensor> createState() => _ViewSensorState();
}

class _ViewSensorState extends State<ViewSensor> {
  int selectedIndex = 1;

  void selectButton(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Carrot patch',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'inter',
                  ),
                ),
                Text('node id'),
              ],
            ),
            SizedBox(height: 10,),
            Text('Node despriction',
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
                    Text('3 min')
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Update'),
                    Text('3 hour')
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
            SizedBox(height: 20,),
            Text('TIME RANGE',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF0AA061),
              ),
            ),
            SizedBox(height: 10,),
            Wrap(
              spacing: 8.0,
              //runSpacing: 8.0,
              children: [OutlinedButton(
                  onPressed: () {
                    selectButton(1);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0AA061),
                    side: selectedIndex == 1 ? BorderSide( color: Colors.white ,width: 0) : BorderSide(color: Colors.black, width: 1.0), // Outline color and thickness
                    backgroundColor: selectedIndex == 1 ? Colors.green : Colors.white, // Fill with green when selected
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                  ),
                  child: Text(
                    'Last 24 Hours',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.white : Colors.black, // Text color changes
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(2);
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF0AA061),
                      side: selectedIndex == 2 ? BorderSide( color: Colors.white ,width: 0) : BorderSide(color: Colors.black, width: 1.0), // Outline color and thickness
                      backgroundColor: selectedIndex == 2 ? Colors.green : Colors.white, // Fill with green when selected
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                  ),
                  child: Text(
                    'Last 7 Days',
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.white : Colors.black, // Text color changes
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(3);
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF0AA061),
                      side: selectedIndex == 3 ? BorderSide( color: Colors.white ,width: 0) : BorderSide(color: Colors.black, width: 1.0), // Outline color and thickness
                      backgroundColor: selectedIndex == 3 ? Colors.green : Colors.white, // Fill with green when selected
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                  ),
                  child: Text(
                    'Last 30 Days',
                    style: TextStyle(
                      color: selectedIndex == 3 ? Colors.white : Colors.black, // Text color changes
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(4);
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF0AA061),
                      side: selectedIndex == 4 ? BorderSide( color: Colors.white ,width: 0) : BorderSide(color: Colors.black, width: 1.0), // Outline color and thickness
                      backgroundColor: selectedIndex == 4 ? Colors.green : Colors.white, // Fill with green when selected
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                  ),
                  child: Text(
                    'Custom',
                    style: TextStyle(
                      color: selectedIndex == 4 ? Colors.white : Colors.black, // Text color changes
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
