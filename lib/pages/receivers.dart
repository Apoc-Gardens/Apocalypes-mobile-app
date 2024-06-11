import 'package:flutter/material.dart';
import '../dao/receiver_dao.dart';
import '../models/receiver.dart';
import '../navigation/side_menu.dart';

class Receivers extends StatefulWidget {
  @override
  _ReceiversState createState() => _ReceiversState();
}

class _ReceiversState extends State<Receivers> {
  final ReceiverDao _receiverDao = ReceiverDao();
  late Future<List<Receiver>> _receiversFuture;

  @override
  void initState() {
    super.initState();
    _receiversFuture = _receiverDao.getAllDevices();
  }

  Future<void> _refreshReceivers() async {
    setState(() {
      _receiversFuture = _receiverDao.getAllDevices();
    });
  }

  void updateName(receiverId, newName) async{
    await _receiverDao.updateReceiverName(receiverId, newName);
    _refreshReceivers();
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
            style: const TextStyle(color: Colors.green),
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
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.green)
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save',
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
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Receivers'),
      ),
      body: FutureBuilder<List<Receiver>>(
        future: _receiversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No receivers found'));
          } else {
            List<Receiver> receivers = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshReceivers,
              child: ListView.builder(
                itemCount: receivers.length,
                itemBuilder: (context, index) {
                  Receiver receiver = receivers[index];
                  return GestureDetector(
                    onLongPress: (){
                      showEditDialog('Name', receiver.name, (newValue) {
                        updateName(receiver.id, newValue);
                      });
                    },
                    child: ListTile(
                      title: Text(receiver.name),
                      subtitle: Text(receiver.mac),
                      trailing: IconButton(onPressed: (){

                      }, icon: const Icon(Icons.delete))
                    ),
                  );
                },
              ),
            );
          }
        },
      )
    );
  }
}