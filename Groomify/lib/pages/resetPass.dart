import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:groomify/pages/login.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPass extends StatelessWidget {
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xffF7D1CD),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Logo
              Container(
                width: w,
                height: h * 0.3,
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "asset/logo.png",
                    ),
                  ),
                ),
              ),
              //Reset Password
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              //Email
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffD1B3C4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                    ]),
                child: SizedBox(
                  width: 280,
                  height: 50,
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xff735D78),
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), width: 1.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              //SizedBox
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () async {
                  String email = emailController.text;
                  ResetPassModel().resetPassword(email, context);
                },
                child: Container(
                  width: w * 0.3,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff735D78),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                      ]),
                  child: Center(
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              //SizedBox
              SizedBox(height: 20,),
              //Text
              RichText(
                  text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      children: [
                        TextSpan(
                            text: " Login Here",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>LoginPage())
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPassModel {
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A Password Reset email has been sent to your inbox. '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Navigate back to the previous page (login page)
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error resetting password: $error');
      // Show error dialog - an error occurred
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while resetting your password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
