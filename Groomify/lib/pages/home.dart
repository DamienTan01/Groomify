import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //Button
            GestureDetector(
              onTap: () {
                AuthController.instance.logout();
              },
              child: Container(
                margin: EdgeInsets.only(top: 100),
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
                    "Logout",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

