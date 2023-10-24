import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/resetPass.dart';
import 'package:groomify/pages/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
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
            const SizedBox(
              height: 30,
            ),
            //Email
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 280,
                height: 50,
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xff735D78),
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            //Password
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 280,
                height: 50,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Color(0xff735D78),
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
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
                  final emailValidationResult = AuthController.instance.validateEmail(emailController.text);
                  final passwordValidationResult = AuthController.instance.validatePassword(passwordController.text);

                  if (emailValidationResult == '' && passwordValidationResult == '') {
                    // Both email and password are valid, proceed with login
                    AuthController.instance.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  } else {
                    // Show error popups for invalid input
                    if (emailValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Email Error', emailValidationResult);
                    }
                    if (passwordValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Password Error', passwordValidationResult);
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //Forgot Password
            RichText(
              text: TextSpan(
                text: "Forgot password? ",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                children: [
                  TextSpan(
                    text: "Reset password",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                      recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const ResetPass())
                  )]
            ),),
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
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignupPage())
                      )
                    ])),
          ],
        ),
      ),
    );
  }
}
