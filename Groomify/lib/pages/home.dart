import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groomify',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffD1B3C4),
        actions: [
          //Log out Button
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 30,
              color: Color(0xff735D78),
              onPressed: () {
                AuthController.instance.logout();
              }
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(

            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
