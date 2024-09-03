import 'package:flutter/material.dart';
import 'package:apoc_gardens/navigation/side_menu.dart';
import 'package:apoc_gardens/widgets/sync-card/sync_card.dart';
import 'package:apoc_gardens/widgets/sensor_card.dart';
import 'package:apoc_gardens/models/node.dart';
import 'package:apoc_gardens/models/receiver.dart';

import '../dao/node_dao.dart';
import '../dao/receiver_dao.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  final NodeDao _nodeDao = NodeDao();
  final ReceiverDao _receiverDao = ReceiverDao();
  late Future<List<Node>> nodesFuture;
  late Future<List<Receiver>> receiversFuture;
  Receiver? selectedReceiver;

  @override
  void initState() {
    super.initState();
    nodesFuture = _nodeDao.getAllNodes();
    receiversFuture = _receiverDao.getAllDevices().then((receivers) {
      if (receivers.isNotEmpty) {
        selectedReceiver = receivers.first;
      }
      return receivers;
    });
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
          FutureBuilder<List<Receiver>>(
            future: receiversFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(), heightFactor: 1, widthFactor: 1);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No receivers found'));
              } else {
                List<Receiver> receivers = snapshot.data!;
                return DropdownButton<Receiver>(
                  value: selectedReceiver,
                  hint: const Text('Select Receiver'),
                  onChanged: (Receiver? newValue) {
                    setState(() {
                      selectedReceiver = newValue;
                    });
                  },
                  items: receivers.map<DropdownMenuItem<Receiver>>((Receiver receiver) {
                    return DropdownMenuItem<Receiver>(
                      value: receiver,
                      child: Text(receiver.name),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Receiver>>(
        future: receiversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No receiver devices saved'));
          } else if (selectedReceiver == null) {
            return const Center(child: Text('Please select a receiver device'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
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
            );
          }
        },
      ),
    );
  }
}