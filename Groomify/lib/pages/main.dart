import 'package:flutter/material.dart';
import 'package:groomify/pages/login.dart';
import 'package:groomify/pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groomify',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffF7D1CD),
        primarySwatch: Colors.blue,
      ),
      home: const SignupPage(),
    );
  }
}