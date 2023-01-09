import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/screens/add_task.dart';
import 'package:todo_firebase/screens/auth/login.dart';
import 'package:todo_firebase/screens/auth/signup.dart';
import 'package:todo_firebase/screens/landing_page.dart';
import 'package:todo_firebase/widgets/tasks_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),

        home: FirebaseAuth.instance.currentUser == null 
        ? const LandingPage(): const TasksList(),

        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
          TasksList.routeName: (ctx) => TasksList(),
          AddTask.routeName: (ctx) => AddTask(),
          LandingPage.routeName: (ctx) => LandingPage(),
        });
  }
  
}
