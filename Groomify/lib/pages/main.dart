import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  //Wait for binding of firebase and authcontroller
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groomify',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffF7D1CD),
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}