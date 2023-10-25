import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomer_home.dart';
import 'package:groomify/pages/groomer_profile.dart';
import 'package:groomify/pages/groomer_btmNavBar.dart';

class GroomerManage extends StatefulWidget {
  const GroomerManage({super.key});

  @override
  State<GroomerManage> createState() => _GroomerManageState();
}

class _GroomerManageState extends State<GroomerManage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerHome()));
    }
    if (index == 1) {
      // Navigate to the Groomer page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerManage()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerProfile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Groomify',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 3.0,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xffD1B3C4),
        actions: [
          //Log out Button
          IconButton(
              icon: const Icon(Icons.logout),
              iconSize: 35,
              color: const Color(0xff735D78),
              onPressed: () {
                AuthController.instance.logout();
              }
          )
        ],
        elevation: 0,
      ),
      body: const SingleChildScrollView (

      ),
      bottomNavigationBar: GroomerNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
