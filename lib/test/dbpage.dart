import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/receiver.dart';
import '../models/datatype.dart';
import '../models/test_table.dart';
import '../services/database_service.dart';

class dbpage extends StatefulWidget {
  const dbpage({super.key});

  @override
  State<dbpage> createState() => _dbpageState();
}

class _dbpageState extends State<dbpage> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    updateCount();
  }

  List<List<String>> data = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> updateCount() async {
    count = (await databaseHelper.getMax())!;
    count++;
  }

  Future<void> inserttest() async {
      int response = await databaseHelper.insertTestData(count, "name $count", "description $count");
      count++;
      print("db response");
      print(response);
  }

  Future<void> readtest() async {
    List<TestTable> testTables = await databaseHelper.getAllTestTables();
    for (var testTable in testTables) {
      print('ID: ${testTable.id}, Name: ${testTable.name}, Description: ${testTable.description}');
    }
  }

  Future<void> readDataTypes() async {
    List<DataType> dataTypes = await databaseHelper.getAllDataTypes();
    for (var dt in dataTypes) {
      print('ID: ${dt.id}, Name: ${dt.name}, Unit: ${dt.unit}');
    }
  }

  Future<void> readDevices() async {
    List<Receiver> devices = await databaseHelper.getAllDevices();
    for (var device in devices) {
      print('ID: ${device.id}, Name: ${device.name}, MAC: ${device.mac}, LastSync: ${device.lastSynced}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
                inserttest();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Insert',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              readtest();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              readDataTypes();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read data types',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              readDevices();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read Devices',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}
