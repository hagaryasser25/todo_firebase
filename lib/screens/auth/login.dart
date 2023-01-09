import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_firebase/screens/auth/signup.dart';
import 'package:todo_firebase/widgets/tasks_list.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();
                  if (email.isEmpty || password.isEmpty) {
                    // show error toast

                    Fluttertoast.showToast(msg: 'Please fill all fields');
                    return;
                  }

                  ProgressDialog progressDialog = ProgressDialog(context,
                      title: Text('Logging In'), message: Text('Please Wait'));
                  progressDialog.show();

                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential userCredential =
                        await auth.signInWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      progressDialog.dismiss();
                      Navigator.pushNamed(context, TasksList.routeName);
                    }
                  } on FirebaseAuthException catch (e) {
                    progressDialog.dismiss();
                    if (e.code == 'user-not-found') {
                      Fluttertoast.showToast(msg: 'User not found');

                    } else if (e.code == 'wrong-password') {
                      Fluttertoast.showToast(msg: 'Wrong password');

                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Something went wrong');
                    progressDialog.dismiss();
                  }

                },
                child: Text('Login')),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not Registerd Yet'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    child: Text('Register Now'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
