import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  final Function addActivity;
  String activity = "";

  final _biggerFont = const TextStyle(fontSize: 18.0);
  AddItemPage({super.key, required this.addActivity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: TextField(
            onChanged: (String value) {
              activity = value;
            },
            onSubmitted: (String value) async {
              activity = value;
              addActivity(activity);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[300]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 128.0),
          child: ElevatedButton(
            onPressed: () {
              addActivity(activity);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                Text("add", style: _biggerFont)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
