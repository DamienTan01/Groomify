import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/login.dart';

//Use to navigate users to all pages
//AuthController is accessible globally
class AuthController extends GetxController {
  //Allow AuthController to be accessible from any pages
  static AuthController instance = Get.find();
  //Declare variable of firebase users (email, pass, name...)
  late Rx<User?> _user;
  //Firebase auth module
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //Keep track of user activity
    _user.bindStream(auth.userChanges());
    //Notify the app the user is logged in or not
    //_initialScreen will be notifed if there's changes made from user (Login and out)
    ever(_user, _initialScreen);
  }

  //Navigate user to LoginPage if the user is not logged in
  _initialScreen(User? user) {
    if (user == null) {
      print("Login Page");
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => HomePage());
    }
  }

  void register(String email, String password, String fullName, String username) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      await firestore.collection('users').add({
        'fullName': fullName,
        'username': username,
        'email': email,
      });
    } catch (e) {
      showErrorPopup(Get.context!, 'Account Creation Failed', 'Invalid Credentials');
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showErrorPopup(Get.context!, 'Login Failed', 'Invalid Credentials');
    }
  }

  void logout() async {
    await auth.signOut();
  }

  //Error Handling
  String validateEmail(String email) {
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return '';
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return '';
  }

  String validateFullName(String fullName) {
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName)) {
      return 'Enter a valid full name (letters and spaces only)';
    }
    return '';
  }

  String validateUserName(String username) {
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return 'Enter a valid username (letters and numbers only)';
    }
    return '';
  }

  bool isLoginButtonEnabled(String email, String password) {
    final emailValid = validateEmail(email) == '';
    final passwordValid = validatePassword(password) == '';
    return emailValid && passwordValid;
  }

  //Display message box
  void showErrorPopup(BuildContext context, String title, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
