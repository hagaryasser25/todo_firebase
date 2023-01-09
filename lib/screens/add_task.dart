import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_firebase/widgets/tasks_list.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/AddTask';
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var taskController = TextEditingController();
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
              controller: taskController,
              decoration: InputDecoration(hintText: 'TaskName'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  String taskName = taskController.text.trim();

                  if (taskName.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide task name');
                    return;
                  }

                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    String uid = user.uid;
                    int dt = DateTime.now().millisecondsSinceEpoch;

                    DatabaseReference taskRef = FirebaseDatabase.instance
                        .reference()
                        .child('tasks')
                        .child(uid);

                    String? taskId = taskRef.push().key;

                    await taskRef.child(taskId!).set({
                      'dt': dt,
                      'taskName': taskName,
                      'taskId': taskId,
                    });
                  }
                  showAlertDialog(context);
                },
                child: Text('Save'))
          ]),
        ));
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, TasksList.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("your task is created"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
