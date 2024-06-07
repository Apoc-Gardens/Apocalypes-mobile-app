import 'package:flutter/material.dart';
import 'package:mybluetoothapp/navigation/side_menu.dart';
import 'package:mybluetoothapp/widgets/sync-card/sync_card.dart';
import 'package:mybluetoothapp/widgets/sensor_card.dart';
import 'package:mybluetoothapp/models/node.dart';

import '../dao/node_dao.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  final NodeDao _nodeDao = NodeDao();
  late Future<List<Node>> nodesFuture;

  @override
  void initState() {
    super.initState();
    nodesFuture = _nodeDao.getAllNodes();
  }

  Future<void> refreshNodes() async {
    setState(() {
      nodesFuture = _nodeDao.getAllNodes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text(
          'Sensors',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'inter',
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: () {
              // Add your onPressed logic here
              Navigator.pushNamed(context, '/test');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0AA061),
              side: const BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0), // Border radius
              ),
              padding: const EdgeInsets.all(6.0), // Padding
            ),
            child: const Text('Add sensor'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Sensors',
            //       style: TextStyle(
            //         fontSize: 26,
            //         fontWeight: FontWeight.bold,
            //         fontFamily: 'inter',
            //       ),
            //     ),
            //     OutlinedButton(
            //       onPressed: () {
            //         // Add your onPressed logic here
            //         Navigator.pushNamed(context, '/test');
            //       },
            //       style: OutlinedButton.styleFrom(
            //         foregroundColor: const Color(0xFF0AA061),
            //         side: const BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(4.0), // Border radius
            //         ),
            //         padding: const EdgeInsets.all(6.0), // Padding
            //       ),
            //       child: const Text('Add sensor'),
            //     ),
            //   ],
            // ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshNodes,
                child: FutureBuilder<List<Node>>(
                  future: nodesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No sensors found'));
                    } else {
                      List<Node> nodes = snapshot.data!;
                      return ListView.builder(
                        itemCount: nodes.length,
                        itemBuilder: (context, index) {
                          return SensorCard(node: nodes[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            SyncCard(),
          ],
        ),
      ),
    );
  }
}
