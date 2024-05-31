import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybluetoothapp/models/node.dart';

import '../services/database_service.dart';

class ViewSensor extends StatefulWidget {
  final Node node;
  const ViewSensor({super.key, required this.node});

  @override
  State<ViewSensor> createState() => _ViewSensorState();
}

class _ViewSensorState extends State<ViewSensor> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int selectedIndex = 1;
  int noOfData = 0;
  int latestTime = 0;
  int oldestTime = 0;
  late List<Map<String, dynamic>> data;
  DateTime now = DateTime.now(); // Get the current time
  late String nodeName;
  late String nodeDescription;

  @override
  void initState() {
    super.initState();
    nodeName = widget.node.name;
    nodeDescription = widget.node.description ?? 'No description';
  }

  Future<void> getData() async {
    await dataCount();
    await getLatestTime();
    await getOldestTime();
    setState(() {});
  }

  Future<void> dataCount() async {
    noOfData = await databaseHelper.countData(widget.node.id.toString()) ?? 0;
  }

  Future<void> getLatestTime() async {
    latestTime = await databaseHelper.latestDataTimeStamp(widget.node.id.toString()) ?? 0;
  }

  Future<void> getOldestTime() async {
    oldestTime = await databaseHelper.oldestDataTimeStamp(widget.node.id.toString()) ?? 0;
  }

  Future<void> getFilteredData(String tableId, int startTime, int endTime) async {
    data = await databaseHelper.getDataByNodeTime(tableId, startTime, endTime);
  }

  void updateName(newName) async{
    int response = await databaseHelper.updateNodeName(widget.node.id.toString(), newName);
    if(response > 0){
      setState(() {
        nodeName = newName;
      });
    }else{
      print('update failed');
    }
  }

  void updateDescription(newDescription) async{
    int response = await databaseHelper.updateNodeDescription(widget.node.id.toString(), newDescription);
    if(response > 0){
      setState(() {
        nodeDescription = newDescription;
      });
    }else{
      print('update failed');
    }
  }

  void selectButton(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void showEditDialog(String title, String initialValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Edit $title',
          style: TextStyle(color: Colors.green),
          ),
          content: TextField(
            cursorColor: Colors.green,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                  style: TextStyle(color: Colors.green)
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save',
                  style: TextStyle(color: Colors.green)
              ),
            ),
          ],
        );
      },
    );
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
                GestureDetector(
                  onTap: () {
                    showEditDialog('Name', widget.node.name, (newValue) {
                      updateName(newValue);
                    });
                  },
                  child: Text(
                    nodeName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'inter',
                    ),
                  ),
                ),
                Text(widget.node.id.toString()),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showEditDialog('Description', widget.node.description ?? '', (newValue) {
                  updateDescription(newValue);
                });
              },
              child: Text(
                nodeDescription,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Update'),
                    Text(DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(latestTime))),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Update'),
                    Text(DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(oldestTime))),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No. Data'),
                    Text(noOfData.toString()),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'TIME RANGE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Color(0xFF0AA061),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                OutlinedButton(
                  onPressed: () {
                    selectButton(1);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0AA061),
                    side: selectedIndex == 1 ? BorderSide(color: Colors.white, width: 0) : BorderSide(color: Colors.black, width: 1.0),
                    backgroundColor: selectedIndex == 1 ? Colors.green : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    'Last 24 Hours',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(2);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0AA061),
                    side: selectedIndex == 2 ? BorderSide(color: Colors.white, width: 0) : BorderSide(color: Colors.black, width: 1.0),
                    backgroundColor: selectedIndex == 2 ? Colors.green : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    'Last 7 Days',
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(3);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0AA061),
                    side: selectedIndex == 3 ? BorderSide(color: Colors.white, width: 0) : BorderSide(color: Colors.black, width: 1.0),
                    backgroundColor: selectedIndex == 3 ? Colors.green : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    'Last 30 Days',
                    style: TextStyle(
                      color: selectedIndex == 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    selectButton(4);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0AA061),
                    side: selectedIndex == 4 ? BorderSide(color: Colors.white, width: 0) : BorderSide(color: Colors.black, width: 1.0),
                    backgroundColor: selectedIndex == 4 ? Colors.green : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    'Custom',
                    style: TextStyle(
                      color: selectedIndex == 4 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
