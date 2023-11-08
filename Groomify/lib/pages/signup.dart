import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/pages/groomer_home.dart';
import 'package:groomify/pages/home.dart';
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
  String selectedRole = 'User';

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
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
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
                  color: const Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 300,
                height: 63,
                child: TextFormField(
                  controller: fullNameController,
                  inputFormatters: [
                    // only accept letters from a to z
                    FilteringTextInputFormatter(RegExp(r'[a-zA-Z]+|\s'), allow: true)
                  ],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.first_page, color: Color(0xff735D78),),
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
            const SizedBox(height: 45,),
            //Username
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffD1B3C4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 3, offset: Offset(2, 3), color: Colors.grey)
                  ]),
              child: SizedBox(
                width: 300,
                height: 63,
                child: TextField(
                  controller: usernameController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.last_page, color: Color(0xff735D78),),
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
            const SizedBox(height: 45,),
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
                      prefixIcon: const Icon(Icons.email, color: Color(0xff735D78),),
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
            const SizedBox(height: 45,),
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
                width: 300,
                height: 63,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.password, color: Color(0xff735D78),),
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
            const SizedBox(height: 45,),
            // Role dropdown
            Container(
              width: 300,
              height: 63,
              decoration: BoxDecoration(
                color: const Color(0xffD1B3C4),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(2, 3),
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.people, color: Color(0xff735D78)),
                    border: InputBorder.none,
                  ),
                  dropdownColor: const Color(0xffD1B3C4),
                  items: <String>['User', 'Groomer'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            //Button
            SizedBox(
              width: w * 0.4,
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
                onPressed: () {
                  final emailValidationResult = AuthController.instance.validateEmail(emailController.text);
                  final passwordValidationResult = AuthController.instance.validatePassword(passwordController.text);
                  final fullNameValidationResult = AuthController.instance.validateFullName(fullNameController.text);
                  final usernameValidationResult = AuthController.instance.validateUserName(usernameController.text);

                  if (emailValidationResult == '' && passwordValidationResult == '') {
                    // Based on the selected role, navigate to the appropriate page
                    if (selectedRole == 'User') {
                      // Both email and password are valid, proceed with registration
                      AuthController.instance.register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        fullNameController.text.trim(), // Provide full name here
                        usernameController.text.trim(),
                        selectedRole,
                      );

                      Get.to(const HomePage());
                    } else if (selectedRole == 'Groomer') {
                      AuthController.instance.groomerRegister(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        fullNameController.text.trim(), // Provide full name here
                        usernameController.text.trim(),
                        selectedRole,
                      );

                      Get.to(const GroomerHome());
                    }

                    AuthController.instance.navigateBasedOnRole(selectedRole);
                  } else {
                    // Show error popups for invalid input
                    if (emailValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Email Error',emailValidationResult);
                    }
                    if (passwordValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Password Error',passwordValidationResult);
                    }
                    if (fullNameValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Full Name Error',fullNameValidationResult);
                    }
                    if (usernameValidationResult.isNotEmpty) {
                      AuthController.instance.showErrorPopup(context, 'Username Error',usernameValidationResult);
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //Text
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
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const LoginPage())
                      )
                    ])),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
