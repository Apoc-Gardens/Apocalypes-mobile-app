import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/receiver.dart';
import '../models/data.dart';
import '../models/datatype.dart';
import '../models/node.dart';
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

  Future<void> readAllnodes() async {
    Map<String,int> sensors = {};
    List<Node> nodes = await databaseHelper.getAllNodes();
    for (var n in nodes) {
      print('ID: ${n.id}, NID: ${n.nid}, Name: ${n.name}, Description: ${n.description}');
    }
    print(sensors);
  }

  Future<void> readData() async {
    List<Data> data = await databaseHelper.getAllData();
    for (var dt in data) {
      print('ID: ${dt.id}, data type: ${dt.dataTypeId}, node id: ${dt.nodeId}, value: ${dt.value}, time: ${dt.timestamp},');
    }
  }

  Future<void> readSpecificNodes() async {
   List<Map<String,dynamic>> nodeid =  await databaseHelper.getNodeById("N001");
   print(nodeid[0]["id"]);
  }

  Future<void> readMapNode() async{
    // Insert a sample node (if not already inserted)
    Node node = Node(id: null, nid: 'N001', name: 'Node 1', description: 'Description for Node 1');
    print("inserted:");
    print(await databaseHelper.insertNode(node));

    // Retrieve and print the node map
    Map<String, int> nodeMap = await databaseHelper.getNodeMap();
    print(nodeMap);

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
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              readMapNode();
              readAllnodes();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read map node',
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
              readSpecificNodes();
              //readAllnodes();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read specififc node',
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
              readData();
              //readAllnodes();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
              ), backgroundColor: Color(0xFF0AA061), // Use your desired color value
            ),
            child: const Text('Read data',
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
