import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopUps{
  void showEditDialog(String title, String initialValue, context, Function(String) onSave) {
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
}