import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateTask extends StatefulWidget {
  static const routeName = '/UpdateTask';
  const UpdateTask({Key? key}) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'TaskName'
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: (){}, child: Text('Save'))
        ]),

      )
    );
  }
}