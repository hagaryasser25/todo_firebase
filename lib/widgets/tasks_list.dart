import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_firebase/screens/add_task.dart';
import 'package:todo_firebase/screens/landing_page.dart';

import '../models/tasks_model.dart';

class TasksList extends StatefulWidget {
  static const routeName = '/TasklistScreen';
  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late DatabaseReference base, base1;
  late FirebaseDatabase database, database1;
  late FirebaseApp app, app1;
  List<Tasks> taskList = [];
  List<String> keyslist = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  getUserData() async {
    User userData = await FirebaseAuth.instance.currentUser!;
    setState(() {
      user = userData;
      print(userData);
      
    });
  }

  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTasks();
  }

  void fetchTasks() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("tasks")
        .child(FirebaseAuth.instance.currentUser!.uid);
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Tasks p = Tasks.fromJson(event.snapshot.value);
      taskList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TodoList'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Text(
                '${user.email}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmation!'),
                          content: Text('Are you sure to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushNamed(
                                    context, LandingPage.routeName);
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddTask.routeName);
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Center(child: Text('No Tasks Added Yet'));
            } else {
              return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    var date = taskList[index].dt;
                    return ListTile(
                        title: Text(
                          taskList[index].taskName.toString(),
                        ),
                        subtitle: Text(getDate(date!)),
                        trailing: IconButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                              base
                                  .child(taskList[index].taskId.toString())
                                  .remove();
                            },
                            icon: Icon(Icons.delete)));
                  });
            }
          },
        ));
  }

  String getDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);

    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
