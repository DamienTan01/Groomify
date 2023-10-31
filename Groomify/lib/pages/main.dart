import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/provider.dart';
import 'package:groomify/pages/login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });

  runApp(
    MultiProvider( // Wrap your app with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedServicesProvider()),
        // Add more providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groomify',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF7D1CD),
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
