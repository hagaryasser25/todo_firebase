import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_firebase/screens/auth/login.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fullNameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup Page')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(hintText: 'FullName'),
            ),
            SizedBox(
              height: 10,
            ),
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
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Confirm Password '),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var fullName = fullNameController.text.trim();
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();
                  var confirmPass = confirmPasswordController.text.trim();

                  if (fullName.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirmPass.isEmpty) {
                    // show error toast

                    Fluttertoast.showToast(msg: 'Please fill all fields');
                    return;
                  }

                  if (password.length < 6) {
                    // show error toast
                    Fluttertoast.showToast(
                        msg:
                            'Weak Password, at least 6 characters are required');

                    return;
                  }

                  if (password != confirmPass) {
                    // show error toast
                    Fluttertoast.showToast(msg: 'Passwords do not match');

                    return;
                  }

                  ProgressDialog progressDialog = ProgressDialog(context,
                      title: Text('Signing Up'), message: Text('Please Wait'));
                  progressDialog.show();

                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential userCredential =
                        await auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      DatabaseReference userRef =
                          FirebaseDatabase.instance.reference().child('users');

                      String uid = userCredential.user!.uid;
                      int dt = DateTime.now().millisecondsSinceEpoch;

                      await userRef.child(uid).set({
                        'fullName': fullName,
                        'email': email,
                        'uid': uid,
                        'dt': dt,
                        'profileImage': ''
                      });

                      Fluttertoast.showToast(msg: 'Success');

                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(msg: 'Failed');
                    }
                    progressDialog.dismiss();
                  } on FirebaseAuthException catch (e) {
                    progressDialog.dismiss();
                    if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(msg: 'Email is already exist');
                    } else if (e.code == 'weak-password') {
                      Fluttertoast.showToast(msg: 'Password is weak');
                    }
                  } catch (e) {
                    progressDialog.dismiss();
                    Fluttertoast.showToast(msg: 'Something went wrong');
                  }
                },
                child: Text('SignUp')),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already Have An Account'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: Text('Login Now'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
