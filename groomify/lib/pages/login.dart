import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: w,
            height: h*0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "asset/logo.png"
                ),
                fit: BoxFit.cover
              ),
            ),
          ),
        ],
      ),
    );
  }
}
