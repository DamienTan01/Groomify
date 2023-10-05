import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/btmNavBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
    }
    if (index == 1) {
      // Navigate to the Profile page
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 3.0,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xffD1B3C4),
        actions: [
          //Log out Button
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 35,
              color: Color(0xff735D78),
              onPressed: () {
                AuthController.instance.logout();
              }
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(

      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
