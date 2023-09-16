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

  //Navigate user to HomePage
  _initialScreen(User? user) {
    //Navigate user to LoginPage if the user is not logged in
    if(user==null) {
      print("Login Page");
      Get.offAll(()=>LoginPage());
    }else {
      Get.offAll(()=>HomePage(email:user.email!));
    }
  }

  //Function for registration
  void register(String email, password) async{
    //Try/catch is used for exceptions when things go wrong
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      Future addDetails(String uid, String username, String email) async {
        await FirebaseFirestore.instance.collection('users').add({
          'uid': uid,
          'username': username,
          'email': email,
        });
      }
    }catch(e) {
      //Prompt a message when registration failed
      Get.snackbar("About User", "User Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Account Creation Failed",
        ),
      );
    }
  }
  void login(String email, password) async{
    //Try/catch is used for exceptions when things go wrong
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e) {
      //Prompt a message when registration failed
      Get.snackbar("About Login", "Empty Fields",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Login Failed",
          ),
          // messageText: Text(
          //   e.toString(),
          //   style: TextStyle(
          //       color: Colors.white
          //   ),
          // )
      );
    }
  }
  void logout() async{
    await auth.signOut();
  }
}