import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            //Full Name
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
                child: TextFormField(
                  inputFormatters: [
                    // only accept letters from a to z
                    FilteringTextInputFormatter(RegExp(r'[a-zA-Z]+|\s'), allow: true)
                  ],
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.first_page, color: Color(0xff735D78),),
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
            SizedBox(height: 50,),
            //Username
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
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.last_page, color: Color(0xff735D78),),
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
            SizedBox(height: 50,),
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
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Color(0xff735D78),),
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
            SizedBox(height: 50,),
            //Password
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
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password, color: Color(0xff735D78),),
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
            SizedBox(height: 50,),
            //Button
            GestureDetector(
              onTap: () {
                final emailValidationResult = AuthController.instance.validateEmail(emailController.text);
                final passwordValidationResult = AuthController.instance.validatePassword(passwordController.text);

                if (emailValidationResult == '' && passwordValidationResult == '') {
                  // Both email and password are valid, proceed with registration
                  AuthController.instance.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    fullNameController.text.trim(), // Provide full name here
                    usernameController.text.trim(), // Provide username here
                  );
                } else {
                  // Show error popups for invalid input
                  if (emailValidationResult.isNotEmpty) {
                    AuthController.instance.showErrorPopup(context, 'Email Error',emailValidationResult);
                  }
                  if (passwordValidationResult.isNotEmpty) {
                    AuthController.instance.showErrorPopup(context, 'Password Error',passwordValidationResult);
                  }
                }
              },
              child: Container(
                width: w * 0.4,
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
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
    );
  }
}
