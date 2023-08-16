import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              width: w,
              height: h * 0.3,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "asset/logo.png",
                  ),
                ),
              ),
            ),
            //First Name
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'First Name',
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
            //Last Name
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Last Name',
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
                width: 250,
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
                width: 250,
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
              onTap: (){
                AuthController.instance.register(emailController.text.trim(), passwordController.text.trim());
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
