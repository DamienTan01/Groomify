import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:groomify/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groomify/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF7D1CD),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Logo
              Container(
                width: w,
                height: h * 0.3,
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "asset/logo.png",
                    ),
                  ),
                ),
              ),
              //Reset Password
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: const Text(
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
                    color: const Color(0xffD1B3C4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 3,
                          offset: Offset(2, 3),
                          color: Colors.grey)
                    ]),
                child: SizedBox(
                  width: 300,
                  height: 63,
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xff735D78),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              //SizedBox
              const SizedBox(
                height: 50,
              ),
              //Button
              SizedBox(
                width: w * 0.3,
                height: h * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color(0xff735D78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    String email = emailController.text;
                    String? result =
                        await ResetPassModel().resetPassword(email, context);

                    if (result != null) {
                      // Display an error message if result is not null
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text(result),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Reset'),
                ),
              ),
              //SizedBox
              const SizedBox(
                height: 30,
              ),
              //Login Page
              RichText(
                  text: TextSpan(
                      text: "Already have an account?",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      children: [
                    TextSpan(
                        text: " Login Here",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => const LoginPage()))
                  ])),
              const SizedBox(
                height: 25,
              ),
              //Signup Page
              RichText(
                  text: TextSpan(
                      text: "Don't have an account?",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      children: [
                    TextSpan(
                        text: " Sign up now",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => const SignupPage()))
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPassModel {
  Future<String?> resetPassword(String email, BuildContext context) async {
    final localContext = context;

    if (email.isEmpty) {
      // Display an error message when the email field is empty
      showDialog(
        context: localContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset'),
            content: const Text('Please enter an email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    String? validateEmail(String email) {
      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
        return 'Enter a valid email address';
      }
      return null;
    }

    final emailValidationMessage = validateEmail(email);

    if (emailValidationMessage != null) {
      // Email is not valid, return the validation message
      return emailValidationMessage;
    }

    // Validate if the entered email is registered as a groomer or user
    final isGroomerEmail = await isEmailRegistered(email, 'groomers');
    final isUserEmail = await isEmailRegistered(email, 'users');

    if (isGroomerEmail || isUserEmail) {
      // Email is registered, proceed with password reset
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // Show success dialog
        showDialog(
          context: localContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Reset'),
              content: const Text(
                  'A Password Reset email has been sent to your inbox. '),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(
                        context); // Navigate back to the previous page (login page)
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return null; // Return null to indicate success
      } catch (error) {
        return 'Password reset failed'; // Return an error message if password reset fails
      }
    } else {
      // Email is not registered, return an error message
      return 'The entered email is not registered.';
    }
  }

  Future<bool> isEmailRegistered(String email, String collectionName) async {
    try {
      final collection = _firestore.collection(collectionName);
      final querySnapshot =
          await collection.where('email', isEqualTo: email).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors, such as Firestore query errors
      return false;
    }
  }
}
