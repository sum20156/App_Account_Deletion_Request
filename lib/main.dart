import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the firebase_app_check plugin
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart'; //--1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "{APP_TITLE}",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPageWidget(),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    showProgressDialog(context);
    await _auth.signOut();
    hideProgressDialog(context);
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  void deleteUserData(String userId) async {
    showProgressDialog(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection("USERS").doc(userId).get().then(
          (DocumentSnapshot doc) {
        if (doc.exists) {
          _firestore.collection("USERS").doc(userId).delete().then(
                  (value) => {
                _auth.currentUser?.delete().then(
                        (value) => {
                      hideProgressDialog(context),
                      showCustomDialog("Account Deleted Successfully",
                          "Good bye! :)")
                    },
                    onError: (e) => {
                      hideProgressDialog(context),
                      showCustomDialog("Error", "Something went wrong")
                    })
              },
              onError: (e) => {
                hideProgressDialog(context),
                showCustomDialog("Error", "Something went wrong")
              });
        } else {
          _auth.currentUser?.delete();
          hideProgressDialog(context);
          showCustomDialog("Error",
              "Account Data not found. May be you have already deleted it.");
        }
      },
      onError: (e) => {
        hideProgressDialog(context),
        showCustomDialog("Error", "Something went wrong")
      },
    );
  }


  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void showConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account Deletion Request"),
          content: Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteUserData(userId); // Delete user data
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  void showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Deletion Request'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 100,
              height: 100,
            ),
            // Change 'your_image.png' to your image path
            SizedBox(height: 20),
            // Optional spacing between image and button
            ElevatedButton(
              onPressed: () async {
                UserCredential userCredential = await signInWithGoogle();
                showConfirmationDialog(
                    userCredential.user!.uid); // Pass userId to dialog
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
